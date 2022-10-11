
locals {
  dev = {
    region            = "ap-northeast-2"
    k8s_instance_type = "t2.micro"
    db_instance_type  = "db.t3.medium"
    application_names = ["k8s-cicd-sample-app"]
    tags              = {
      Owner       = "my-sample"
      Environment = "dev"
    }
  }
}

module "dev" {
  source            = "./cluster"
  tags              = local.dev.tags
  k8s_instance_type = local.dev.k8s_instance_type
  db_instance_type  = local.dev.db_instance_type
  application_names = local.dev.application_names
  ecr_aws_region    = local.dev.region
}