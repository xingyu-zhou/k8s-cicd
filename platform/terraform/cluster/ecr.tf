module "ecr" {
  source                 = "cloudposse/ecr/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  for_each               = toset(var.ecr_names)
  namespace              = "k8s"
  stage                  = "${var.env_name}"
  name                   = each.key
  principals_full_access = [module.iam_assumable_role.iam_role_arn,module.lb_role.iam_role_arn]
}