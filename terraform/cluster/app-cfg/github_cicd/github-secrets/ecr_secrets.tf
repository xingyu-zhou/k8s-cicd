
resource "github_actions_environment_secret" "ecr_aws_region" {
  repository       = var.repo_name
  environment      = var.repo_environment
  secret_name      = "ECR_AWS_REGION"
  plaintext_value  = var.ecr_aws_region
}

resource "github_actions_environment_secret" "ecr_aws_endpoint" {
  repository       = var.repo_name
  environment      = var.repo_environment
  secret_name      = "ECR_AWS_ENDPOINT"
  plaintext_value  = var.ecr_aws_endpoint
}

resource "github_actions_environment_secret" "aws_access_key" {
  repository       = var.repo_name
  environment      = var.repo_environment
  secret_name      = "ECR_AWS_ACCESS_KEY_ID"
  plaintext_value  = var.aws_access_key
}

resource "github_actions_environment_secret" "aws_access_key_secret" {
  repository       = var.repo_name
  environment      = var.repo_environment
  secret_name      = "ECR_AWS_SECRET_ACCESS_KEY"
  plaintext_value  = var.aws_access_key_secret
}
