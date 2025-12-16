# Name for the web server and related resources
# This will be used as a prefix for resource names and tags
variable "server_name" {
  description = "Name for the web server instance"
  default     = "SG-Deploy-With-PR"
}

# EC2 instance size configuration (CPU, memory, network performance)
# t2.micro is eligible for AWS free tier
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "region_selection" {
  description = "Region to deploy to"
  default     = "us-east-1"
}

