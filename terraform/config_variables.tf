variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "network_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

data "http" "allowed_admin_ip" {
  url = "https://api.ipify.org?format=text"
}

variable "ubuntu_ami_id" {
  description = "AMI ID for Ubuntu instances"
  type        = string
  default     = "ami-084568db4383264d4"
}

variable "amz_linux_ami_id" {
  description = "AMI ID for Amazon Linux instances"
  type        = string
  default     = "ami-071226ecf16aa7d96"
}

variable "admin_host_instance_type" {
  description = "Instance type for the admin (bastion) host"
  type        = string
  default     = "t2.micro"
}

variable "internal_host_instance_type" {
  description = "Instance type for internal (private) instances"
  type        = string
  default     = "t2.micro"
}

variable "num_internal_hosts" {
  description = "Number of private EC2 instances"
  type        = number
  default     = 6
}
