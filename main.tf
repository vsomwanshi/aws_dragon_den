terraform {
  required_providers {
    rhcs = {
      version = ">= 1.0.5"
      source  = "terraform-redhat/rhcs"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "rhcs" {
  token = var.offline_access_token
  url   = var.url
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
  assume_role {
    role_arn     = var.role_arn
    session_name = var.session_name
}
}
