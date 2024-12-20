data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" #IN PRODUCTION, ONYLY USE LEAST PRIVILEGE
}

resource "aws_instance" "bastion-host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.public-subnet[0].id

  vpc_security_group_ids = [aws_security_group.bastion-sg.id]

  root_block_device {
    volume_size = var.bastion_instance_volume
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_role.name

  tags = {
    Name = "Bastion_Host"
  }
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}
