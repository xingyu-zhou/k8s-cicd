
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
  default = "my-k8s-cluster"
}

variable "k8s_instance_type" {
  default = "t3.large"
}

variable "ecr_names" {
  default = ["dev-k8s-cluster-repo"]
}
