variable "aws_region" {
  description = "The AWS region in which terraform operations will be performed"
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster in the current AWS region"
}

variable "instance_name" {
  description = "The instance name of this echo deployment.  To avoid conflicts, this must be unique among all instance deployments"
}

variable "app_env" {
  description = "The application deployment environment"
}

variable "deployment_owner" {
  description = "The owner of this deployment of the app. Typically used for ephemeral deployments"
  default = ""
}

variable "owner_email" {
  description = "The email address of the deployement owner"
}

variable "owner_slack" {
  description = "The slack channel of the deployment owner"
  default = ""
}

variable "namespace" {
  description = "The namespace in which the service will be deployed"
}

variable "replicas" {
  description = "The number of service replicas to deploy"
  default = "3"
}

variable "image" {
  description = "The docker image to deploy"
}

variable "smoke_test_image" {
    description = "The docker image for the smoke test"
}

variable "functional_test_image" {
    description = "The docker image for the functional test"
}

variable "performance_test_image" {
    description = "The docker image for the performance test"
}

variable "scale_test_image" {
    description = "The docker image for the scale test"
}


variable "kafka_endpoint" {
  description = "Hostname and port of the kafka bootstrap server"
  default = "kafka.core:9092"
}

variable "token_endpoint" {
  description = "Hostname and port of the token service"
  default = "token.core:80"
}

