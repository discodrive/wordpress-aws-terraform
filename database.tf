resource "aws_db_subnet_group" "db_subnets" {
  name       = "db_subnets"
  subnet_ids = [aws_subnet.private_subnet_3.id, aws_subnet.private_subnet_4.id]
}

# Create RDS cluster - required for Aurora databases
# Figure out how to build this and the instance from variables
resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = "test-cluster"
  db_subnet_group_name    = aws_db_subnet_group.db_subnets.name
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.1"
  availability_zones      = ["eu-west-1"]
  database_name           = "database"
  master_username         = "username"
  master_password         = "password"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
}

# Create cluster instance
resource "aws_rds_cluster_instance" "db_instance" {
  identifier          = aws_rds_cluster.db_cluster.database_name
  cluster_identifier  = aws_rds_cluster.db_cluster.cluster_identifier
  instance_class      = "db.t2.micro"
  engine              = aws_rds_cluster.db_cluster.engine
  engine_version      = aws_rds_cluster.db_cluster.engine_version
  publicly_accessible = false
}
