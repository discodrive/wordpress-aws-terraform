resource "aws_instance" "server_1a" {
    # Linux 2 AMI 
    ami = "ami-0b026d11830afcbac"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet_1.id
    availability_zone = data.aws_availability_zones.available.names[0]

    # Import user data from a shell script in the same directory
    user_data = "${templatefile("init.sh", {
        efs_path = aws_efs_file_system.wordpress_efs.dns_name
    })}"

    # Import an existing key pair for SSH access to the instance
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.web_server_security_group.id]

    tags = {
        Name = "Server 1a"
    }
}

resource "aws_instance" "server_1b" {
    # Linux 2 AMI 
    ami = "ami-0b026d11830afcbac"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet_2.id
    availability_zone = data.aws_availability_zones.available.names[1]

    # Import user data from a shell script in the same directory
    user_data = "${templatefile("init.sh", {
        efs_path = aws_efs_file_system.wordpress_efs.dns_name
    })}"

    # Import an existing key pair for SSH access to the instance
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.web_server_security_group.id]

    tags = {
        Name = "Server 1b"
    }
}
