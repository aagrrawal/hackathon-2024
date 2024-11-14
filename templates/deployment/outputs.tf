output "k8s_service_endpoint" {
  description = "The kubernetes endpoint for the service"
  value = module.echo.k8s_service_endpoint
}

output "smoke_test_image" {
  description = "The docker image for the smoke test"
  value = module.echo.smoke_test_image
}

output "functional_test_image" {
  description = "The docker image for the functional test"
  value = module.echo.functional_test_image
}

output "performance_test_image" {
  description = "The docker image for the performance test"
  value = module.echo.performance_test_image
}

output "scale_test_image" {
  description = "The docker image for the scale test"
  value = module.echo.scale_test_image
}


output "namespace" {
  description = "The namespaces in which the service was deployed"
  value = module.echo.namespace
}

output "owner_labels" {
  description = "The ownership labels for the service"
  value = module.echo.owner_labels
}

output "owner_annotations" {
  description = "The ownership annotations for the service"
  value = module.echo.owner_annotations
}