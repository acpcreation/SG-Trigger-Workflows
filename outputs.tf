# Displays the public IP address of the created EC2 instance
# This IP can be used to access the server from the internet
output "web_instance_public_ip" {
    value = aws_instance.web.public_ip
}

# Provides the complete SSH command to connect to the instance
# Copy and paste this command to access your server via SSH
output "ssh_command" {
    # value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.web.public_ip}"
    value = "ssh -i id_rsa ec2-user@${aws_instance.web.public_ip}"
}


