variable "tags" {
  default = {
    Owner       = "github-app"
    Environment = "dev"
  }
}

variable "env_name" {
  default = "dev"
}

variable "repo_name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "applications_names" {
  default = ["dev-k8s-sample"]
}

variable "cluster_name" {}
variable "eks_cluster_id" {}
variable "ecr_aws_region" {}
variable "db_endpoint" {}
variable "db_username" {}
variable "db_password" {}