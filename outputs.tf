# Root Module - Output Definitions
# These are the final outputs visible after terraform apply

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "nginx_public_ip" {
  description = "Public IP address of the Nginx server"
  value       = module.ec2.public_ip
}

output "nginx_url" {
  description = "URL to access the Nginx server"
  value       = "http://${module.ec2.public_ip}"
}