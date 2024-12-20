

resource "aws_vpc" "projectX-vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.cluster_name}-main-vpc"
  }
}

#CLUSTER SECURITY GROUP
resource "aws_security_group" "eks-cluster-sg" {
  name        = var.cluster-sg-name
  description = "Allow 443  from bastion host"

  vpc_id = aws_vpc.projectX-vpc.id

  ingress {
    from_port   = 443 
    to_port     = 443
    protocol    = "tcp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.cluster-sg-name
  }
}

#BASTION HOST SECURITY GROUP
resource "aws_security_group" "bastion-sg" {
  name        = "Bastion_Host"
  description = "Server as the single source of entry to the private subnet"

  vpc_id = aws_vpc.projectX-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Use your trusted IP here, this is a security risk, don't allow it like this. It should be your IP Address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion_Host"
  }
}