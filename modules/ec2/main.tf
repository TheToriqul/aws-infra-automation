# EC2 Module - Main Configuration
# This creates an EC2 instance with Nginx in a Docker container

# Security group for the EC2 instance
resource "aws_security_group" "ec2" {
  name        = "${var.environment}-nginx-sg"
  description = "Security group for Nginx EC2 instance"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  # Allow HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  # Allow SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "${var.environment}-nginx-sg"
  }
}

# Amazon Linux 2 AMI
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

# EC2 instance with Nginx Docker
resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.ssh_key_name != "" ? var.ssh_key_name : null

  # Script that runs when the instance first starts
  user_data = <<-EOF
              #!/bin/bash
              # Update system packages
              yum update -y
              
              # Install Docker
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              
              # Run Nginx container
              docker run -d -p 80:80 --name nginx nginx:latest
              EOF

  tags = {
    Name = "${var.environment}-nginx-instance"
  }

  # Set the size of the root disk
  root_block_device {
    volume_type = "gp2"
    volume_size = 8

    tags = {
      Name = "${var.environment}-nginx-volume"
    }
  }
}