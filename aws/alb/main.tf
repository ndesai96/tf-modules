resource "aws_lb" "main" {
  name            = "${var.app_name}-alb"
  subnets         = var.public_subnets
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "main" {
  name             = "${var.app_name}-tg"
  port             = var.app_port
  protocol         = var.app_protocol
  protocol_version = var.app_protocol_version
  vpc_id           = var.vpc_id
  target_type      = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = var.app_protocol_version == "GRPC" ? "0-12" : "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the load balancer to the target group
resource "aws_lb_listener" "https_with_mtls" {
  count = var.enable_mtls ? 1 : 0

  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }

  mutual_authentication {
    mode            = "verify"
    trust_store_arn = aws_lb_trust_store.main[0].arn
  }
}

resource "aws_lb_listener" "https_without_mtls" {
  count = var.enable_mtls ? 0 : 1

  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }
}

# Redirect HTTP traffic to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
