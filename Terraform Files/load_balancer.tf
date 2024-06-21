resource "aws_lb" "prod_lb" {
  name               = "production-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.main_a.id, aws_subnet.main_b.id]
}

resource "aws_lb_target_group" "prod_tg" {
  name     = "production-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}

resource "aws_lb_listener" "prod_listener" {
  load_balancer_arn = aws_lb.prod_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "prod_tg_attachment" {
  count            = length(var.production_instance_ids)
  target_group_arn = aws_lb_target_group.prod_tg.arn
  target_id        = element(var.production_instance_ids, count.index)
  port             = 80
}
