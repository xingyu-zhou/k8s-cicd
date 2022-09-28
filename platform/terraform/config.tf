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

data "aws_availability_zones" "available" {
}

module "dev_vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "~> 3.0"
  name             = "dev-k8s-vpc"
  cidr             = "172.16.0.0/16"
  azs              = data.aws_availability_zones.available.names
  private_subnets  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets   = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  database_subnets = ["172.16.7.0/24", "172.16.8.0/24", "172.16.9.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/dev" = "shared"
    "kubernetes.io/role/elb"    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/dev"       = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}