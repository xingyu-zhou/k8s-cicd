variable "vpc_id" {}

variable "private_subnet_ids" {}

variable "database_subnet_group_name" {}

variable "private_subnets_cidr_blocks" {}

variable "tags" {
  default= {
    Owner       = "k8s-cluster"
    Environment = "dev"
  }
}

variable "env_name"{
  default = "dev"
}

variable "cluster_name" {
  default = "my-cluster"
}

variable "k8s_instance_type" {
  default = "t3.large"
}

variable "database_name" {
  default   = "dev-aurora-mysql-cluster"
}

variable "db_instance_type" {
  default = "db.r5.large"
}
