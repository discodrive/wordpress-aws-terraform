variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name_tag          = string
  }))
}

variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    name_tag          = string
  }))
}
