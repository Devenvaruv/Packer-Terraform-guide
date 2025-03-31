############################################
#  AWS Provider
############################################
provider "aws" {
  region = var.region
}

############################################
#  VPC Module
############################################
module "network_infra" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.network_name
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = var.environment
  }
}

############################################
#  Security Groups
############################################
resource "aws_security_group" "admin_sg" {
  name        = "admin-access-sg"
  description = "Allow SSH only from the allowed admin IP"
  vpc_id      = module.network_infra.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.allowed_admin_ip.body}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_sg" {
  name        = "internal-access-sg"
  description = "Allow SSH from admin host"
  vpc_id      = module.network_infra.vpc_id

  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    security_groups   = [aws_security_group.admin_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
#  EC2 Instances
############################################
resource "aws_instance" "admin_host" {
  ami                         = var.amz_linux_ami_id
  instance_type               = var.admin_host_instance_type
  subnet_id                   = module.network_infra.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.admin_sg.id]
  associate_public_ip_address = true
  key_name                    = "vockey"

  tags = {
    Name = "Admin Host"
  }
}

resource "aws_instance" "internal_hosts" {
  count                  = var.num_internal_hosts
  ami                    = count.index < 3 ? var.ubuntu_ami_id : var.amz_linux_ami_id
  instance_type          = var.internal_host_instance_type
  subnet_id              = element(module.network_infra.private_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.internal_sg.id]
  key_name               = "vockey"

  tags = {
    Name = "Internal Host ${count.index + 1}"
    OS   = count.index < 3 ? "ubuntu" : "amazon"
  }
}