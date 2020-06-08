resource "aws_instance" "bastion" {
	ami = var.ec2_ami
	instance_type = var.ec2_instance_type
	key_name = var.bastion_key_name
	subnet_id = aws_subnet.public_sub2.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.bastion_sg.id]
	root_block_device {
		volume_size = 15
	}

  tags = {
    Name = "capstoneBastion"
    Type = "Bastion"
  }
}
