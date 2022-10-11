resource "null_resource" "get_kube_config" {
  triggers = {
    cluster_name = var.eks_cluster_id
  }
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.eks_cluster_id}"
  }
}

data "local_file" "kube_config" {
  filename   = "~/.kube/config"
  depends_on = ["null_resource.get_kube_config"]
}

resource "github_actions_environment_secret" "kube_config" {
  repository       = var.repo_name
  environment     = var.repo_environment
  secret_name     = "KUBECONFIG"
  plaintext_value = data.local_file.kube_config.content
}

