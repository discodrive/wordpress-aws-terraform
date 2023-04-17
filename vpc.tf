resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main.id
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
resource "aws_route_table_association" "subnet_association_a" {
  subnet_id      = aws_subnet.public_primary.id
  route_table_id = aws_default_route_table.public_route_table.id
}

resource "aws_route_table_association" "subnet_association_b" {
  subnet_id      = aws_subnet.public_secondary.id
  route_table_id = aws_default_route_table.public_route_table.id
}
