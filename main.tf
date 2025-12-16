# Data source to fetch the latest Amazon Linux 2 AMI for the selected region
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group that controls network access to the EC2 instance
resource "aws_security_group" "web_sg" {
    name        = "${var.server_name}-security-group"
    description = "Security group for ${var.server_name}"
    vpc_id      = data.aws_vpc.vpc_cidr.id

    # Allow inbound SSH traffic on port 22 from any IP address
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow inbound HTTP traffic on port 80 from any IP address
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.server_name}-security-group"
    }
}

# EC2 instance (virtual server) configuration
resource "aws_instance" "web" {
    ami           = data.aws_ami.amazon_linux.id       # Dynamically fetched Amazon Linux 2 AMI
    instance_type = var.instance_type                  # Instance size (CPU/memory)
    subnet_id     = aws_subnet.web_subnet.id           # Which subnet to place the instance in
    vpc_security_group_ids = [aws_security_group.web_sg.id]  # Security rules

    tags = {
        Name = var.server_name
    }
}
