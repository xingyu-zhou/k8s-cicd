################################################################################
# RDS Aurora Module
################################################################################

module "rds-aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.5.1"

  name           = var.cluster_name
  engine         = "aurora-mysql"
  engine_version = "5.7"
  instances      = {
    1 = {
      identifier     = "mysql-static-1"
      instance_class = var.instance_class
    }
    2 = {
      identifier     = "mysql-excluded-1"
      instance_class = var.instance_class
      promotion_tier = 15
    }
  }

  vpc_id                 = var.vpc_id
  db_subnet_group_name   = var.db_subnet_group_name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = var.allowed_cidr_blocks

  iam_database_authentication_enabled = true
  master_password                     = random_password.master.result
  create_random_password              = false

  apply_immediately   = true
  skip_final_snapshot = true

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = var.cluster_name
  db_cluster_parameter_group_family      = "aurora-mysql5.7"
  db_cluster_parameter_group_description = "${var.cluster_name} example cluster parameter group"
  db_cluster_parameter_group_parameters  = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
    }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
    }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "immediate"
    }, {
      name         = "max_allowed_packet"
      value        = "67108864"
      apply_method = "immediate"
    }, {
      name         = "aurora_parallel_query"
      value        = "OFF"
      apply_method = "pending-reboot"
    }, {
      name         = "binlog_format"
      value        = "ROW"
      apply_method = "pending-reboot"
    }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
    }, {
      name         = "require_secure_transport"
      value        = "ON"
      apply_method = "immediate"
    }, {
      name         = "tls_version"
      value        = "TLSv1.2"
      apply_method = "pending-reboot"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = var.cluster_name
  db_parameter_group_family      = "aurora-mysql5.7"
  db_parameter_group_description = "${var.cluster_name} example DB parameter group"
  db_parameter_group_parameters  = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
    }, {
      name         = "general_log"
      value        = 0
      apply_method = "immediate"
    }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
    }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "pending-reboot"
    }, {
      name         = "long_query_time"
      value        = 5
      apply_method = "immediate"
    }, {
      name         = "max_connections"
      value        = 2000
      apply_method = "immediate"
    }, {
      name         = "slow_query_log"
      value        = 1
      apply_method = "immediate"
    }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
    }
  ]

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  security_group_use_name_prefix  = false

  tags = var.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "random_password" "master" {
  length = 10
}