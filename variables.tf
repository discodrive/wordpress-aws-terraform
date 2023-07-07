variable "alb_ingress_rules" {
  type = list(object({
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = string
    description = string
  }))
}

variable "web_server_ingress_rules" {
  type = list(object({
    from_port   = string
    to_port     = string
    protocol    = string
    description = string
  }))
}

variable "key_name" {
  type = string
  description = "The name of an existing key pair to allow ssh access to EC2 instances"
}
