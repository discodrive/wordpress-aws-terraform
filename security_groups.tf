# Application Load Balancer security group
resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "Application security group"
  vpc_id      = aws_vpc.main.id
}

# ALB accepts traffic from the internet
resource "aws_security_group_rule" "alb_security_group_rules" {
  count = length(var.alb_ingress_rules)

  type              = "ingress"
  from_port         = var.alb_ingress_rules[count.index].from_port
  to_port           = var.alb_ingress_rules[count.index].to_port
  protocol          = var.alb_ingress_rules[count.index].protocol
  cidr_blocks       = [var.alb_ingress_rules[count.index].cidr_blocks]
  description       = var.alb_ingress_rules[count.index].description
  security_group_id = aws_security_group.alb_security_group.id
}

# Web server security group
resource "aws_security_group" "web_server_security_group" {
  name        = "web_server_security_group"
  description = "EC2 instance security group"
  vpc_id      = aws_vpc.main.id
}

# Severs accept traffic only from ALB
resource "aws_security_group_rule" "web_server_security_group_rules" {
  count = length(var.web_server_ingress_rules)

  type                     = "ingress"
  from_port                = var.web_server_ingress_rules[count.index].from_port
  to_port                  = var.web_server_ingress_rules[count.index].to_port
  protocol                 = var.web_server_ingress_rules[count.index].protocol
  source_security_group_id = aws_security_group.alb_security_group.id
  description              = var.web_server_ingress_rules[count.index].description
  security_group_id        = aws_security_group.web_server_security_group.id
}

# Database security group
resource "aws_security_group" "database_security_group" {
  name        = "database_security_group"
  description = "Database layer security group"
  vpc_id      = aws_vpc.main.id
}

# Database accessible only by application server
resource "aws_security_group_rule" "database_security_group_rules" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.web_server_security_group.id
  description              = "MYSQL/Aurora access"
  security_group_id        = aws_security_group.database_security_group.id
}

# Elastic File System security group
resource "aws_security_group" "efs_security_group" {
  name        = "efs_security_group"
  description = "Elastic File System security group"
  vpc_id      = aws_vpc.main.id
}

# EFS accessible only by application server
resource "aws_security_group_rule" "efs_security_group_rules_1" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.web_server_security_group.id
  description              = "EFS web server access"
  security_group_id        = aws_security_group.efs_security_group.id
}

resource "aws_security_group_rule" "efs_security_group_rules_2" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.efs_security_group.id
  description              = "EFS security group access - self"
  security_group_id        = aws_security_group.efs_security_group.id
}

# Security group for SSH access to EC2 instances
resource "aws_security_group" "ssh_security_group" {
  name        = "ec2_ssh_security_group"
  description = "Allows SSH access to EC2 instances"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ssh_security_group_rules" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "SSH"
  cidr_blocks       = ["0.0.0.0/0"] # Replace with my IP only
  description       = "SSH access to EC2"
  security_group_id = aws_security_group.ssh_security_group.id
}
