alb_ingress_rules = [
  {
    from_port   = "80"
    to_port     = "80"
    protocol    = "http"
    cidr_blocks = "0.0.0.0/0"
    description = "HTTP access from internet"
  },
  {
    from_port   = "443"
    to_port     = "443"
    protocol    = "https"
    cidr_blocks = "0.0.0.0/0"
    description = "HTTPS access from internet"
  },
]

web_server_ingress_rules = [
  {
    from_port   = "80"
    to_port     = "80"
    protocol    = "http"
    description = "HTTP access from ALB"
  },
  {
    from_port   = "443"
    to_port     = "443"
    protocol    = "https"
    description = "HTTPS access from ALB"
  },
]

db_config = [
  {
    cluster_name       = "test_cluster"
    db_name            = "database"
    db_username        = "username"
    db_password        = "password"
    availability_zones = "eu-west-1"
  },
]
