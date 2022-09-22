terraform {
  required_version = ">= 0.14.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.0.3"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "dev_cluster" {
  source        = "./cluster"
  cluster_name  = "dev"
  #instance_type = "t2.micro"
  instance_type = "t3.medium"
}
