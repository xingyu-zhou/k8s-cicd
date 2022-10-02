variable "tags" {
  default= {
    Owner       = "rds-cluster"
    Environment = "dev"
  }
}
variable "cluster_name" {}
variable "vpc_id" {}
variable "db_subnet_group_name" {}
variable "allowed_cidr_blocks" {}
variable "instance_class" {}