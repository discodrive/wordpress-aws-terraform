<a href="https://terraform.io">
    <img src=".github/tf.png" alt="Terraform logo" title="Terraform" align="left" height="50" />
</a>

# Terraform script for AWS hosted WordPress sites

This set of Terraform files provisions all of the resources required for hosting a WordPress website entirely on AWS using a typical 3 tier application architecture.

## Resources Provisioned

The following resources will be provisioned with this script:

- VPC, Internet gateway, Elastic IPs, NAT gateways
- Subnets:
-- 2x public subnets
-- 4x private subnets
- Routing tables
- 2x EC2 instances
- Application Load Balancer associated with EC2 instances
- Aurora RDS cluster
- Security groups for each tier of the application
- 2x Elastic File System mounted on the database tier private subnets


## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | -------- |
