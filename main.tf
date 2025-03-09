# Main Terraform Configuration
# This file connects all the modules together

# Define which Terraform version and providers we need
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Using local state instead of S3
  # The state will be stored in the terraform.tfstate file locally

  required_version = ">= 1.0.0"
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Create the VPC and subnets using the VPC module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = "${var.aws_region}a"
  environment         = var.environment
}

# Create the EC2 instance with Nginx using the EC2 module
module "ec2" {
  source = "./modules/ec2"

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  instance_type = var.instance_type
  environment   = var.environment
  ssh_key_name  = var.ssh_key_name
}