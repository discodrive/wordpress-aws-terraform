private_subnets = [
    {
        cidr_block = "10.0.2.0/24"
        availability_zone = "0"
        name_tag = "Private Subnet 1 - App Tier"
    },
    {
        cidr_block = "10.0.3.0/24"
        availability_zone = "0"
        name_tag = "Private Subnet 2 - App Tier"
    },
    {
        cidr_block = "10.0.4.0/24"
        availability_zone = "1"
        name_tag = "Private Subnet 3 - DB Tier"
    },
    {
        cidr_block = "10.0.5.0/24"
        availability_zone = "1"
        name_tag = "Private Subnet 4 - DB Tier"
    }
    
]
