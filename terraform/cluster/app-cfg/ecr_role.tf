
 resource "aws_iam_role" "this" {
   for_each               = toset(var.applications_names)
   name               = each.key
   assume_role_policy = module.iam_policy.
 }

//noinspection MissingModule
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
