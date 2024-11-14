terraform {
  required_providers {
      aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    slack = {
      source  = "terraform.tivo.com/pablovarela/slack"
      version = "= 1.2.0-tivo.2"
    }
  }
  required_version = "~> 1.3"
}
