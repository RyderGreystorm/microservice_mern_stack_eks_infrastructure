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

resource "aws_key_pair" "bastion-key" {
  key_name   = "deployer-key"
  public_key = file(var.pub_key)
} 

resource "aws_instance" "bastion-host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_instance_type
  subnet_id = aws_subnet.public-subnet[0].id
  key_name = aws_key_pair.bastion-key.key_name
  vpc_security_group_ids = [ aws_security_group.bastion-sg.id ]

  root_block_device {
    volume_size = var.bastion_instance_volume
  }
  tags = {
    Name = "Bastion_Host"
  }
}

