terraform {
  required_version = ">=1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=4.50.0"
    }
  }
}


provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      managed_by = "Terraform"
      git_source = "RhysDeimel/zero_downtime_deployment"
    }
  }
}
