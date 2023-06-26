resource "aws_efs_file_system" "wordpress_efs" {
  creation_token = "wordpress_efs"
}

# Elastic file system is mounted to the database tier private subnets
resource "aws_efs_mount_target" "wordpress_efs_mount_target_1" {
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.private_subnet_3.id
  security_groups = [aws_security_group_rule.efs_security_group_rules_2.id]

  depends_on = [
    aws_efs_file_system.wordpress_efs
  ]
}

resource "aws_efs_mount_target" "wordpress_efs_mount_target_2" {
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.private_subnet_4.id
  security_groups = [aws_security_group_rule.efs_security_group_rules_2.id]

  depends_on = [
    aws_efs_file_system.wordpress_efs
  ]
}
