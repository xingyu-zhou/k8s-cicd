locals {
  dev = {
    ecr               = ["test-app-repo"]
    k8s_instance_type = "t2.micro"
    database_name     = "dev-aurora-mysql-cluster"
    db_instance_type  = "db.t3.medium"
    tags              = {
      Owner       = "my-k8s-sample"
      Environment = "dev"
    }
  }
}

module "dev_k8s_cluster" {
  source            = "./cluster"
  tags              = local.dev.tags
  env_name          = local.dev.tags.Environment
  cluster_name      = local.dev.tags.Owner
  ecr_names         = local.dev.ecr
  k8s_instance_type = local.dev.k8s_instance_type
}

resource "kubernetes_secret_v1" "my-secrets" {
  metadata {
    name = "mysecret"
  }

  data = {
    endpoint = module.rds-aurora.cluster_endpoint
    username = module.rds-aurora.cluster_master_username
    password = module.rds-aurora.cluster_master_password
  }

  type = "kubernetes.io/basic-auth"
}
