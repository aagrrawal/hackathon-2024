terraform {
  required_providers {
      aws = {
      source = "hashicorp/aws"
      version = ">= 2.57.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    tivo = {
      source = "terraform.tivo.com/tivocorp/tivo"
      version = ">= 0.2.0"
    }
  }
  required_version = ">= 1.0"
}
