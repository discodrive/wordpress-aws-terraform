# Terraform script for AWS hosted WordPress sites

This set of Terraform files provisions all of the resources required for hosting a WordPress website entirely on AWS using a typical 3 tier application architecture.

## Resources Provisioned

The following resources will be provisioned with this script:

- VPC, Internet gateway, Elastic IPs, NAT gateways
- Subnets:
    - 2x public subnets
    - 4x private subnets
- Routing tables
- 2x EC2 instances
- Application Load Balancer associated with EC2 instances
- Aurora RDS cluster
- Security groups for each tier of the application
- 2x Elastic File System mounted on the database tier private subnets
- CloudFront distribution and cache policies

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | -------- |
| `alb_ingress_rules` | Load balancer security group ingress rules | List of objects | - | Required |
| `web_server_ingress_rules` | Web server security group ingress rules | List of objects | - | Required |
| `key_name` | Name of the key pair to be used for SSH access | String | - | Required |
| `domain_name` | Domain name of the app. e.g. website.com | String | - | Required |
| `origin_id` | Identifier for the origin. e.g. app-name | String | - | Required |
