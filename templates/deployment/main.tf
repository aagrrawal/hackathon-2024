terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "tivo-inception-k8s-terraform-storage-dev"
    dynamodb_table = "tivo-inception-k8s-terraform-locking-dev"
    # do not specify key - the inception-k8s-docker-helper auto sets it to a path based on the datacenter,
    # service, and instance_name
    region = "us-east-1"
  }
}

locals {
  image_user                       = var.user == "build" ? "" : "${var.user}/"
  kafka_collector_image_tag        = "2022.06.11-191900"
  sidecar_image_tag                = "main-24"
  kafka_collector_image            = format("docker.tivo.com/kafka-collector:%s", local.kafka_collector_image_tag)
  sidecar_image                    = format("docker.tivo.com/k8s-bs35-sidecar:%s", local.sidecar_image_tag)
  aws_region                       = "us-east-1"
  eks_cluster_name                 = var.eks_cluster_name
  service_name                     = "kafka-collector"
  bs35_environment_name            = "core"
  owner_email                      = var.owner_email
  deployment_owner                 = var.user
  termination_grace_period_seconds = 30
  bs35_datacenter                  = "tea2"
  service_port                     = 40093
  proxy_sidecar_port               = 3000
  cpu_limit                        = "2"
  memory_limit                     = "5Gi"
  cpu_request                      = "500m"
  memory_request                   = "1Gi"
  cpu_average_utilization          = 80
  max_unavailable_percent          = "50%"
}

locals {
  config_data = file("${path.module}/kafka-collector-configmap.json")
}
provider "aws" {
  region = var.aws_region
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
    api_version = "client.authentication.k8s.io/v1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = "aws"
  }
}

module "namespace" {
  source              = "github.com/tivocorp/inception-k8s-terraform//modules/namespace?ref=v6.0.5"
  name                = "kafka-collector-${var.ephemeral_name}"
  slack_alert_channel = var.slack_alert_channel
}

module "kafka_collector" {
  source                           = "./modules/kafka-collector"
  service_name                     = local.service_name
  instance_name                    = var.ephemeral_name
  bs35_environment_name            = local.bs35_environment_name
  deployment_owner                 = local.deployment_owner
  owner_email                      = local.owner_email
  namespace                        = module.namespace.this_namespace_name
  kafka_collector_image            = local.kafka_collector_image
  sidecar_image                    = local.sidecar_image
  bs35_region_name                 = var.aws_region
  owner_slack                      = var.slack_alert_channel
  termination_grace_period_seconds = local.termination_grace_period_seconds
  bs35_datacenter                  = local.bs35_datacenter
  service_port                     = local.service_port
  proxy_sidecar_port               = local.proxy_sidecar_port
  cpu_limit                        = local.cpu_limit
  cpu_request                      = local.cpu_request
  memory_limit                     = local.memory_limit
  memory_request                   = local.memory_request
  cpu_average_utilization          = local.cpu_average_utilization
  kafka_collector_config           = kubernetes_config_map_v1.kafka_collector_config.metadata.0.name
  replicas                         = var.replicas
  max_unavailable_percent          = local.max_unavailable_percent
}

resource "kubernetes_config_map_v1" "kafka_collector_config" {
  metadata {
    name      = "kafka-collector"
    namespace = module.namespace.this_namespace_name
  }
  data = {
    "kafka-collector.json" = <<EOT
    ${local.config_data}
EOT
  }
}
