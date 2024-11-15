output "namespace" {
  description = "The namespaces in which the service was deployed"
  value = module.kafka_collector.namespace
}

output "owner_labels" {
  description = "The ownership labels for the service"
  value = module.kafka_collector.owner_labels
}

output "owner_annotations" {
  description = "The ownership annotations for the service"
  value = module.kafka_collector.owner_annotations
}

output "proxy_sidecar_port" {
  description = "port on which the k8s-bs35-proxy sidecar listens"
  value = module.kafka_collector.proxy_sidecar_port
}
