terraform {
  backend "s3" {
    encrypt             = true
    bucket              = "tivo-inception-k8s-terraform-storage-dev"
    dynamodb_table      = "tivo-inception-k8s-terraform-locking-dev"
    # do not specify key - the inception-k8s-docker-helper auto sets it to a path based on the datacenter,
    # service, and instance_name
    region              = "us-east-1"
  }
}

locals {
  image_user = var.user == "build" ? "" : "${var.user}/"
  image_tag = var.user == "build" ? var.ephemeral_name : "latest"
  image = format("docker.tivo.com/%secho:%s", local.image_user, local.image_tag)
  smoke_test_image = format("docker.tivo.com/%secho_smoke-test:%s", local.image_user, local.image_tag)
  functional_test_image = format("docker.tivo.com/%secho_functional-test:%s", local.image_user, local.image_tag)
  performance_test_image = format("docker.tivo.com/%secho_performance-test:%s", local.image_user, local.image_tag)
  scale_test_image = format("docker.tivo.com/%secho_scale-test:%s", local.image_user, local.image_tag)
}

provider "aws" {
  region  = var.aws_region
}

data "aws_ssm_parameter" "slack_token" {
  name = "/dev-shared/kubernetes/monitoring/slack-token"
}

provider "slack" {
  token = data.aws_ssm_parameter.slack_token.value
}

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}

module "namespace" {
  source = "github.com/tivocorp/inception-k8s-terraform//modules/namespace?ref=v6.0.5"
  name = "echo-${var.ephemeral_name}"
  slack_alert_channel = "sanjaykumarc-alerts"
}

module "echo" {
  source = "./modules/echo"
  aws_region = var.aws_region
  eks_cluster_name = var.eks_cluster_name
  instance_name = var.ephemeral_name
  app_env = "dev"
  deployment_owner = var.user
  owner_email = var.owner_email
  namespace = module.namespace.this_namespace_name
  image = local.image
  smoke_test_image = local.smoke_test_image
  functional_test_image = local.functional_test_image
  performance_test_image = local.performance_test_image
  scale_test_image = local.scale_test_image
}
