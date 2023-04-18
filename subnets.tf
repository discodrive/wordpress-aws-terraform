# Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index].cidr_block
  availability_zone       = data.aws_availability_zones.available.names[var.public_subnets[count.index].availability_zone]
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnets[count.index].name_tag
  }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  availability_zone = data.aws_availability_zones.available.names[var.private_subnets[count.index].availability_zone]

  tags = {
    Name = var.private_subnets[count.index].name_tag
  }
}
