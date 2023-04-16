# Public Subnets
resource "aws_subnet" "public_primary" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet 1"
    }
}

resource "aws_subnet" "public_secondary" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet 2"
    }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets[count.index].cidr_block
    availability_zone = data.aws_availability_zones.available.names[var.private_subnets[count.index].availability_zone]

    tags = {
        Name = var.private_subnets[count.index].name_tag
    }
}
