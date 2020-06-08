resource "aws_instance" "db" {
	ami = var.ec2_ami
	instance_type = var.ec2_instance_type
	key_name = var.db_key_name
	subnet_id = aws_subnet.private_sub.id
	security_groups = [aws_security_group.db_sg.id]
	root_block_device {
		volume_size = 15
	}

	tags = {
	Name = "capstoneDB"
	Type = "DB"
	}
}
