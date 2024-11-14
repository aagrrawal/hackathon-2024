variable "aws_region" {
  description = "The AWS region in which terraform operations will be performed"
  default = "us-east-1"
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster in the current AWS region"
  default = "tek2"
}

variable "ephemeral_name" {
  description = "The instance name of this ephemeral deployment. To avoid conflicts, this must be unique among all instance deployments"
}

variable "app_version" {
  description = "The release version of the application"
  default = "0.0.1"
}

variable "owner_email" {
  description = "The email address of the deployment owner"
  default = "inception-scrum@tivo.com"
}

variable "user" {
  description = "The username running the ephemeral deployment"
}

variable "slack_alert_channel" {
  description = "The name of the slack channel to which alerts should be sent"
}