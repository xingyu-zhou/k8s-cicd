#resource "github_actions_environment_secret" "ecr_aws_region" {
##  repository       = data.github_repository.repo.name
#  repository       = github_repository.repo.name
#  environment      = github_repository_environment.repo_environment.environment
#  secret_name      = "ECR_AWS_REGION"
#  plaintext_value  = var.ecr_aws_region
#}
#
#resource "github_actions_environment_secret" "ecr_aws_endpoint" {
##  repository       = data.github_repository.repo.name
#  repository       = github_repository.repo.name
#  environment      = github_repository_environment.repo_environment.environment
#  secret_name      = "ECR_AWS_ENDPOINT"
#  plaintext_value  = var.ecr_aws_endpoint
#}
#
#resource "github_actions_environment_secret" "aws_access_key" {
##  repository       = data.github_repository.repo.name
#  repository       = github_repository.repo.name
#  environment      = github_repository_environment.repo_environment.environment
#  secret_name      = "ECR_AWS_ACCESS_KEY_ID"
#  plaintext_value  = var.aws_access_key
#}
#
#resource "github_actions_environment_secret" "aws_access_key_secret" {
##  repository       = data.github_repository.repo.name
#  repository       = github_repository.repo.name
#  environment      = github_repository_environment.repo_environment.environment
#  secret_name      = "ECR_AWS_SECRET_ACCESS_KEY"
#  plaintext_value  = var.aws_access_key_secret
#}
