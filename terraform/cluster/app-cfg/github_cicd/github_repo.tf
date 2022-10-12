data "github_repository" "repo" {
  full_name = var.repo_name
}

resource "github_repository_environment" "repo_environment" {
  count       = length(data.github_repository.repo) > 0?1 : 0
  repository  = data.github_repository.repo.name
  environment = var.environment

}
resource "github_repository" "repo" {
  count = length(data.github_repository.repo) > 0?0 : 1
  name  = var.repo_name

  visibility = "private"

  #  template {
  #    owner      = "github"
  #    repository = "k8s-cicd-app-template"
  #  }
}


resource "github_repository_environment" "repo_environment" {
  count       = length(data.github_repository.repo) > 0?0 : 1
  repository  = github_repository.repo.name
  environment = var.environment
}