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

# NAT gateways for 
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.elastic_ip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.elastic_ip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
}

# Configure the default route table. Terraform doesn't create a new route table, but adopts the default, clears existing defined routes and uses only rules specified in the terraform configuration.
resource "aws_default_route_table" "public_route_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }
}

# Associate public subnets with route table
resource "aws_route_table_association" "subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_default_route_table.public_route_table.id
}

resource "aws_route_table_association" "subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_default_route_table.public_route_table.id
}
