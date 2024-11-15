output "namespace" {
  description = "The namespace in which the service was deployed"
  value = var.namespace
}

output "owner_labels" {
  description = "The ownership labels for the service"
  value = local.owner_labels
}

output "owner_annotations" {
  description = "The ownership annotations for the service"
  value = local.owner_annotations
}

output "proxy_sidecar_port" {
  description = "port on which the k8s-bs35-proxy sidecar listens"
  value = var.proxy_sidecar_port
}
