#module "github_secrets" {
#  source = "github-secrets"
#
#  for_each = tomap(module.ecr)
#  ecr_aws_region        = var.ecr_aws_region
#  aws_access_key        = var.aws_access_key
#  aws_access_key_secret = var.aws_access_key_secret
#  eks_cluster_id        = var.eks_cluster_id
#  environment           = var.env_name
#  ecr_aws_endpoint      = each.value.repository_url
#  repo_name             = each.value.repository_name
##  repo_name             = "xingyu-zhou/${each.value.repository_name}"
#}
#
#resource "kubernetes_secret_v1" "k8s-secrets" {
#  metadata {
#    name = "mysecret"
#  }
#
#  data = {
#    endpoint = var.db_endpoint
#    username = var.db_username
#    password = var.db_password
#  }
#
#  type = "kubernetes.io/basic-auth"
#}