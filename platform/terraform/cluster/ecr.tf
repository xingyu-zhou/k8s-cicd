module "ecr" {
  source = "cloudposse/ecr/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  namespace              = "k8s"
  stage                  = "${var.env_name}"
  name                   = "${var.env_name}_${var.cluster_name}"
  principals_full_access = [module.iam_assumable_role.iam_role_arn]
}