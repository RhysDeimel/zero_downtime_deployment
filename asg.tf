resource "aws_autoscaling_group" "this" {
  name = "foo_asg"

  health_check_type         = "ELB"
  health_check_grace_period = 60

  min_elb_capacity      = 1
  wait_for_elb_capacity = 1

  desired_capacity = 2
  min_size         = 2
  max_size         = 2

  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id = aws_launch_template.this.id
    # Make sure not to use AWS’s internal $Latest alias; otherwise, Terraform will not have awareness to cascade changes when the version number increases.
    version = aws_launch_template.this.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    # triggers = ["tag"]
  }

  lifecycle {
    # need to ignore because we're using the aws_autoscaling_attachment resource
    ignore_changes = [load_balancers, target_group_arns]
  }
}


resource "aws_launch_template" "this" {
  name_prefix   = "foo"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  update_default_version = true

  vpc_security_group_ids = [aws_security_group.foo.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    version = var.foo_version
  }))

  iam_instance_profile {
    name = "AmazonSSMManagedInstanceCore"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "foo-${var.foo_version}"
    }
  }
}


resource "aws_autoscaling_attachment" "foo" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn    = aws_lb_target_group.this.arn
}
