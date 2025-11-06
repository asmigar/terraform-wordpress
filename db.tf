data "aws_db_cluster_snapshot" "wordpress_db_snapshot" {
  db_cluster_identifier = "aurora-cluster-wordpress" # Replace with your snapshot ARN or identifier
  most_recent          = true # Set to true to get the latest snapshot
}

resource "random_string" "snapshot_identifier_suffix" {
  length           = 4
  special          = false
}

resource "aws_rds_cluster" "wordpress" {
  cluster_identifier      = "aurora-cluster-wordpress"
  engine                  = "aurora-mysql"
  engine_mode = "provisioned"
  engine_version          = "8.0.mysql_aurora.3.10.1"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_subnet_group_name = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.db.id]
  database_name           = "wordpress_db"
  master_username         = "wordpress_user"
  master_password         = "your_strong_password"
  snapshot_identifier = data.aws_db_cluster_snapshot.wordpress_db_snapshot.id
  skip_final_snapshot = false
  final_snapshot_identifier = "aurora-cluster-wordpress-${random_string.snapshot_identifier_suffix.id}"
  apply_immediately = true
  preferred_backup_window = "07:00-09:00"

  serverlessv2_scaling_configuration {
    max_capacity             = 1.0
    min_capacity             = 0.0
    seconds_until_auto_pause = 300
  }
}


resource "aws_rds_cluster_instance" "wordpress" {
  cluster_identifier = aws_rds_cluster.wordpress.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.wordpress.engine
  engine_version     = aws_rds_cluster.wordpress.engine_version
}

resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress"
  subnet_ids = aws_subnet.db_subnets[*].id

  tags = {
    Name = "Wordpress DB subnet group"
  }
}

