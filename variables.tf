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

variable "db_config" {
  type = list(object({
    cluster_name = string
    db_name = string
    db_username = string
    db_password = string
    availability_zones = list
  }))
}
