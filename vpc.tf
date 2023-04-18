resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main.id
}

# Elastic IPs for use with public subnets
resource "eip" "elastic_ips" {
  for_each = aws_subnet.public_subnets

  vpc = true
  public_ipv4_pool = "amazon"
}

# NAT gateways for 
resource "aws_nat_gateway" "nat_gateway" {
  for_each = aws_subnet.public_subnets

  allocation_id = [ for eip in eip.elastic_ips : eip.id ]
  subnet_id = each.value.id
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
resource "aws_route_table_association" "subnet_association" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_default_route_table.public_route_table.id
}
