output "k8s_service_endpoint" {
  description = "The kubernetes endpoint for the service"
  value = "${kubernetes_service_v1.echo.metadata.0.name}.${kubernetes_service_v1.echo.metadata.0.namespace}:${kubernetes_service_v1.echo.spec.0.port.0.port}"
}

output "smoke_test_image" {
  description = "The docker image for the smoke test"
  value = var.smoke_test_image
}

output "functional_test_image" {
  description = "The docker image for the functional test"
  value = var.functional_test_image
}

output "performance_test_image" {
  description = "The docker image for the performance test"
  value = var.performance_test_image
}

output "scale_test_image" {
  description = "The docker image for the scale test"
  value = var.scale_test_image
}


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
