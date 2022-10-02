output "vpc_id" {
  value = module.vpc.vpc_id
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "aws_access_key" {
  value = module.iam_user.iam_access_key_id
}

output "aws_access_key_secret" {
  value = module.iam_user.iam_access_key_secret
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "maintenance_role_arn" {
  value = module.iam_assumable_role.iam_role_arn
}
output "eks_role_arn" {
  value = module.lb_role.iam_role_arn
}