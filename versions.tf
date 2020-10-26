terraform {
  required_version = ">= 0.12.26"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.12.0"
    }
  }
}
