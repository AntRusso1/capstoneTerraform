resource "aws_launch_configuration" "asg_conf" {
  name = "capstoneWeb"
  image_id = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.web_key_name
  security_groups = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 15
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "capstoneWeb"
  launch_configuration = aws_launch_configuration.asg_conf.name
  desired_capacity = 2
  min_size = 2
  max_size = 4
  health_check_grace_period = 300
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_subnet.public_sub1.id]
  target_group_arns = [aws_lb_target_group.capstoneTG.arn]
  lifecycle {
    create_before_destroy = true
  }

  tag {
  key = "Name"
  value = "capstoneWeb"
  propagate_at_launch = true
  }

  tag {
  key = "Type"
  value = "Web"
  propagate_at_launch = true
  }

  depends_on = [aws_launch_configuration.asg_conf, aws_lb.capstoneLB, aws_lb_target_group.capstoneTG]
}
