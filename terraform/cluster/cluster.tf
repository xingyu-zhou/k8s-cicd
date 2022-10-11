module "eks_cluster" {
  source            = "./eks-cluster"
  tags              = var.tags
  env_name          = var.tags.Environment
  cluster_name      = "eks-${var.tags.Owner}"
  k8s_instance_type = var.k8s_instance_type
}

module "rds_cluster" {
  source               = "./rds-cluster"
  cluster_name         = "rds-${var.tags.Owner}"
  instance_class       = var.db_instance_type
  vpc_id               = module.eks_cluster.vpc_id
  db_subnet_group_name = module.eks_cluster.database_subnet_group_name
  allowed_cidr_blocks  = module.eks_cluster.private_subnets_cidr_blocks
}

module "applications" {
  source             = "./app-cfg"
  applications_names = var.application_names
  env_name           = var.tags.Environment
  eks_cluster_id     = module.eks_cluster.cluster_id
  db_endpoint        = module.rds_cluster.db_endpoint
  db_username        = module.rds_cluster.db_username
  db_password        = module.rds_cluster.db_password
  ecr_aws_region     = var.ecr_aws_region
  cluster_name       = module.eks_cluster.cluster_name
}