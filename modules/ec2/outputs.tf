# EC2 Module - Output Definitions

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nginx.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nginx.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2.id
}