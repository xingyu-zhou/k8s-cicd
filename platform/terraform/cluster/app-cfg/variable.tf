variable "tags" {
  default = {
    Owner       = "github-app"
    Environment = "dev"
  }
}

variable "env_name" {
  default = "dev"
}

variable "applications_names" {
  default = ["dev-k8s-sample"]
}

variable "aws_access_key" {}
variable "aws_access_key_secret" {}
variable "ecr_aws_region" {}
variable "eks_cluster_id" {}
variable "db_endpoint" {}
variable "db_username" {}
variable "db_password" {}

variable "ecr_access_roles" {}