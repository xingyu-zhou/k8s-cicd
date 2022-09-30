terraform {
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
