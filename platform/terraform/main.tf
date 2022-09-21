module "dev_cluster" {
  source        = "./cluster"
  cluster_name  = "dev"
  instance_type = "t2.micro"
  #instance_type = "t3.medium"
}
