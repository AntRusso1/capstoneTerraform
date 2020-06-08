resource "aws_security_group" "bastion_sg" {
	  name = "bastion_sg"
	  description = "Bastion default access security group"
	  vpc_id = aws_vpc.main.id

	  ingress {
	    from_port = 22
	    to_port = 22
	    protocol = "tcp"
	    cidr_blocks = ["148.36.114.23/32"]
		}

	  egress {
	    from_port = 0
	    to_port = 0
	    protocol = "-1"
	    cidr_blocks = ["0.0.0.0/0"]
	  }

	  tags = {
	    Name = "bastion_sg"
			Type = "Bastion"
	  }
}

resource "aws_security_group" "web_sg" {
    name = "web_sg"
		description = "Allows web traffic to web servers"
		vpc_id = aws_vpc.main.id

		ingress {
		  from_port = 80
		  to_port = 80
		  protocol = "tcp"
		  cidr_blocks = ["0.0.0.0/0"]
		}

		egress {
		  from_port = 0
		  to_port = 0
		  protocol = "-1"
		  cidr_blocks = ["0.0.0.0/0"]
		}

		tags = {
		  Name = "web_sg"
			Type = "Web"
		}
}

resource "aws_security_group" "db_sg" {
	name = "db_sg"
	description = "Database security group"
	vpc_id = aws_vpc.main.id

	ingress {
		from_port = 3306
		to_port = 3306
		protocol = "tcp"
		security_groups = [aws_security_group.web_sg.id]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = [aws_security_group.bastion_sg.id]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "db_sg"
		Type = "DB"
	}
}

resource "aws_security_group_rule" "splunk1" {
  type              = "ingress"
  from_port         = 9997
  to_port           = 9997
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion_sg.id
	source_security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "splunk2" {
  type              = "ingress"
  from_port         = 8089
  to_port           = 8089
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion_sg.id
	source_security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
	source_security_group_id = aws_security_group.bastion_sg.id
}
