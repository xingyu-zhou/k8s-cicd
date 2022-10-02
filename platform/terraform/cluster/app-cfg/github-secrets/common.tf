#data "github_repository" "repo" {
#  full_name = var.repo_name
#}

resource "github_repository" "repo" {
  name = var.repo_name

  visibility = "private"

  #  template {
  #    owner      = "github"
  #    repository = "terraform-module-template"
  #  }
}

resource "github_repository_environment" "repo_environment" {
  #  repository       = data.github_repository.repo.name
  repository  = github_repository.repo.name
  environment = var.environment
}