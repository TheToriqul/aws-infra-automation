# EC2 Module - Variable Definitions

variable "vpc_id" {
  description = "ID of the VPC where EC2 will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where EC2 will be deployed"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "dev"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
  default     = ""
}