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
  description = "Max and Min replicas for HPA."
  type = map(number)
  default = {
    "min"  = 2
    "max"  = 3
  }
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

variable "proxy_sidecar_port" {
  description = "The port on which k8s-bs35-proxy sidecar listens"
}

variable "termination_grace_period_seconds" {
  description = "Time period to wait before force killing the pod"
}

variable "cpu_limit" {
  description = "cpu allocation limit"
}

variable "memory_limit" {
  description = "memory allocation limit"
}

variable "cpu_request" {
  description = "request cpu allocation"
}

variable "memory_request" {
  description = "request memory allocation"
}

variable "sidecar_cpu_limit" {
  description = "cpu allocation limit"
  default = "500m"
}

variable "sidecar_memory_limit" {
  description = "memory allocation limit"
  default = "512Mi"
}

variable "sidecar_cpu_request" {
  description = "request cpu allocation"
  default = "100m"
}

variable "sidecar_memory_request" {
  description = "request memory allocation"
  default = "128Mi"
}

variable "sidecar_image" {
  description = "The docker image to deploy"
}

variable "service_port" {
  description = "The admin port of the service"
}
variable "bs35_datacenter" {
  description = "BS35 datacenter that the kafka-collector operates on."
}
variable "bs35_environment_name" {
  description = "The application deployment environment"
}

variable "pdb_min_available" {
  default = ""
}

variable "deployment_timeouts_create" {
  default = ""
}
variable "deployment_timeouts_update" {
  default = ""
}
variable "deployment_spec_replicas" {
  default = ""
}
variable "deployment_spec_template_spec_max_skew" {
  default = ""
}
variable "deployment_spec_template_spec_topology_spread_constraint" {
  default = ""
}
variable "deployment_spec_container_readiness_probe_port" {
  default = ""
}
variable "deployment_spec_container_container_port_service" {
  default = ""
}
variable "deployment_spec_container_container_port_metrics" {
  default = ""
}
variable "deployment_spec_container_resources_limits_cpu" {
  default = ""
}
variable "deployment_spec_container_resources_limits_memory" {
  default = ""
}
variable "deployment_spec_container_resources_requests_cpu" {
  default = ""
}
variable "deployment_spec_container_resources_requests_memory" {
  default = ""
}
variable "pdb_max_unavailable" {
  default = ""
}
variable "service_name" {
  default = ""
}
variable "hpa_spec_max_replicas" {
  default = ""
}
variable "hpa_spec_min_replicas" {
  default = ""
}
variable "hpa_spec_metric_cpu_utilization_average_utilization" {
  default = ""
}

variable "bs35_region_name" {
  default = ""
}
variable "app_config" {
  default = ""
}