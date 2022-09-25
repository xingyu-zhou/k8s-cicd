locals {
  dev = {
    k8s_instance_type = "t2.micro"
    db_instance_type  = "db.t3.medium"
    tags              = {
      Owner       = "my-k8s-sample"
      Environment = "dev"
    }
  }
}

module "dev_k8s_cluster" {
  source                      = "./cluster"
  tags                        = local.dev.tags
  env_name                    = local.dev.tags.Environment
  cluster_name                = local.dev.tags.Owner
  k8s_instance_type           = local.dev.k8s_instance_type
  db_instance_type            = local.dev.db_instance_type
  vpc_id                      = module.dev_vpc.vpc_id
  private_subnet_ids          = module.dev_vpc.private_subnets
  private_subnets_cidr_blocks = module.dev_vpc.private_subnets_cidr_blocks
  database_subnet_group_name  = module.dev_vpc.database_subnet_group_name
}