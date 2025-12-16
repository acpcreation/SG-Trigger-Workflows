# TERRAFORM

# Virtual Private Cloud (VPC) - isolated network environment in AWS
# Commented out to use existing VPC instead of creating a new one
resource "aws_vpc" "vpc_cidr"{
    cidr_block = "10.0.0.0/16"           # IP address range for the VPC (65,536 IP addresses)
    enable_dns_hostnames = true          # Enable DNS hostnames for instances
    enable_dns_support = true            # Enable DNS resolution

    tags = {
        Name = "web-vpc"
    }
}

# Data source to reference existing VPC
# data "aws_vpc" "vpc_cidr" {
#     id = "vpc-064c66aaba2ac7fed"  # Using specified VPC ID
# }

# Public subnet where the EC2 instance will be placed
resource "aws_subnet" "web_subnet" {
    vpc_id                  = data.aws_vpc.vpc_cidr.id
    cidr_block              = "10.0.2.0/24"                 # Subnet IP range (256 IP addresses)
    availability_zone       = "${var.region_selection}a"    # Physical location within the region
    map_public_ip_on_launch = true                          # Automatically assign public IP to instances

    tags = {
        Name = "web-subnet"
    }
}

# Internet Gateway - allows internet access to/from the VPC
# Commented out to use existing internet gateway
resource "aws_internet_gateway" "web_igw" {
    vpc_id = data.aws_vpc.vpc_cidr.id

    tags = {
        Name = "web-igw"
    }
}

# Data source to reference existing internet gateway
# data "aws_internet_gateway" "web_igw" {
#     filter {
#         name   = "attachment.vpc-id"
#         values = [data.aws_vpc.vpc_cidr.id]
#     }
# }

# Route table - defines network routing rules
resource "aws_route_table" "web_rt" {
    vpc_id = data.aws_vpc.vpc_cidr.id

    # Route all traffic (0.0.0.0/0) to the internet gateway
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.web_igw.id
    }

    tags = {
        Name = "web-route-table"
    }
}

# Associates the route table with the subnet
resource "aws_route_table_association" "web_rta" {
    subnet_id      = aws_subnet.web_subnet.id
    route_table_id = aws_route_table.web_rt.id
}
