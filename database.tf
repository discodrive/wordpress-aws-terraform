resource "aws_db_subnet_group" "db_subnets" {
    name = "db_subnets"
    subnet_ids = [aws_subnet.private_subnet_3.id, aws_subnet.private_subnet_4.id]
}

# Create RDS cluster - required for Aurora databases
resource "aws_rds_cluster" "db_cluster" {
    count = length(var.db_config)

    cluster_identifier      = var.db_config[count.index].cluster_name
    db_subnet_group_name = aws_db_subnet_group.db_subnets.name
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.1"
    availability_zones      = var.db_config[count.index].availability_zones
    database_name           = var.db_config[count.index].db_name
    master_username         = var.db_config[count.index].db_username
    master_password         = var.db_config[count.index].db_password
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    vpc_security_group_ids  = [aws.security_group.database_security_group.id]
}

# Create cluster instance
resource "aws_rds_cluster_instance" "db_instance" {
    for_each = aws_rds_cluster.db_cluster
    
    identifier          = each.value.database_name
    cluster_identifier  = each.value.id
    instance_class      = "db.t2.micro"
    engine              = each.value.engine
    engine_version      = each.value.engine_version
    publicly_accessible = false
}
