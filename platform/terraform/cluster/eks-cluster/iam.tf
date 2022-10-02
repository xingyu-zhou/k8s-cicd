module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = "${var.env_name}-deploy-${var.cluster_name}"
  force_destroy = true

  pgp_key = "keybase:test"

  password_reset_required = false
}

module "iam_assumable_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    module.iam_user.iam_user_arn
  ]

  create_role = true

  role_name         = "deploy_${var.cluster_name}"
  role_requires_mfa = true

  custom_role_policy_arns = [
    module.iam_policy.arn
  ]
  number_of_custom_role_policy_arns = 1
}

module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "example"
  path        = "/"
  description = "${var.cluster_name} example deploy policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
           "ecr:BatchCheckLayerAvailability",
           "ecr:InitiateLayerUpload",
           "ecr:UploadLayerPart",
           "ecr:CompleteLayerUpload",
           "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "eks:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "*",
      "Condition": {
          "StringEquals": {
              "iam:PassedToService": "eks.amazonaws.com"
          }
      }
    }
  ]
}
EOF
}