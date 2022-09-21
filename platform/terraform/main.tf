module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "ap-northeast-1a",
    "ap-northeast-1d",
    "ap-northeast-1c"]
  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "additional" {
  name_prefix = "security-additional"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name = "my-cluster"
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.my_key.arn
      resources = [
        "secrets"]
    }]

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type = "m6i.large"
    update_launch_template_default_version = true
    vpc_security_group_ids       = [aws_security_group.additional.id]
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  self_managed_node_groups = {
    one = {
      name = "mixed-1"
      max_size = 5
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy = "capacity-optimized"
        }

        override = [
          {
            instance_type = "m5.large"
            weighted_capacity = "1"
          },
          {
            instance_type = "m6i.large"
            weighted_capacity = "2"
          },
        ]
      }
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size = 50
    instance_types = [
      "m6i.large",
      "m5.large",
      "m5n.large",
      "m5zn.large"]
    attach_cluster_primary_security_group = true
    vpc_security_group_ids = [aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size = 1
      max_size = 10
      desired_size = 1

      instance_types = [
        "t3.large"]
      capacity_type = "SPOT"
    }
  }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
  }

  # aws-auth configmap
  //  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn = "arn:aws:iam::910121505252:role/aws-reserved/sso.amazonaws.com/ap-northeast-1/AWSReservedSSO_PowerUser-and-billing-Role_8cba44d7e1e7be14"
      username = "AWSReservedSSO_PowerUser-and-billing-Role_8cba44d7e1e7be14"
      groups = [
        "system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn = "arn:aws:iam::910121505252:user/lin.li@kinto-mobility.biz"
      username = "lin.li@kinto-mobility.biz"
      groups = [
        "system:masters"]
    },
  ]

  aws_auth_accounts = [
    "910121505252",
  ]

  //  mysecret = [
  //    {
  //      username = "admin",
  //      password = "12345",
  //    },
  //  ]
  tags = {
    Environment = "dev"
    Terraform = "true"
  }
}


resource "aws_kms_key" "my_key" {
  description = "KMS key 1"
  deletion_window_in_days = 10
}

//resource "aws_db_subnet_group" "default" {
//  name       = "db_group"
//  subnet_ids = module.vpc.database_subnets
//
//  tags = {
//    Name = "My DB subnet group"
//  }
//}

module "DBcluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name = "test-aurora-db-mysql"
  engine = "aurora-mysql"
  engine_version = "5.7"
  instance_class = "db.t4g.medium"
  instances = {
    one = {}
    2 = {
      instance_class = "db.t4g.medium"
    }
  }

  vpc_id = module.vpc.vpc_id
//  db_subnet_group_name = aws_db_subnet_group.default.name
  subnets = module.vpc.database_subnets
  vpc_security_group_ids = [aws_security_group.additional.id]
  allowed_security_groups = [
    module.eks.node_security_group_id,
    module.eks.cluster_security_group_id,
    module.eks.cluster_primary_security_group_id
  ]

  allowed_cidr_blocks = [
    "10.0.0.0/16"]

  storage_encrypted = true
  apply_immediately = true
  monitoring_interval = 10

  //  db_parameter_group_name = "default"
  //  db_cluster_parameter_group_name = "default"

  tags = {
    Environment = "dev"
    Terraform = "true"
  }
}

resource "kubernetes_secret" "mysecret" {
  data = {
    "username" = module.DBcluster.cluster_master_username,
    "password" = module.DBcluster.cluster_master_password,
    "endpoint" = module.DBcluster.cluster_endpoint
  }

  metadata {
    name = "mysecret"
    namespace = "default"
  }
  type = "kubernetes.io/basic-auth"
}