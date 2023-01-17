resource "aws_lb" "this" {
  name               = "foo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
}


resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}


resource "aws_lb_target_group" "this" {
  name_prefix = "foo"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  deregistration_delay = 60

  health_check {
    path = "/"
  }

  lifecycle {
    create_before_destroy = true
  }
}
