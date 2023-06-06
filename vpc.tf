resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main.id
}

# Elastic IPs for use with public subnets
resource "aws_eip" "elastic_ip_1" {
  vpc              = true
  public_ipv4_pool = "amazon"
}

resource "aws_eip" "elastic_ip_2" {
  vpc              = true
  public_ipv4_pool = "amazon"
}

# NAT gateways
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.elastic_ip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "NAT Gateway Public Subnet 1"
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.elastic_ip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "NAT Gateway Public Subnet 2"
  }
}
