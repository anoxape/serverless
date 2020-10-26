### lb

resource "aws_lb" "lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb.id]
  subnets         = var.vpc_public_subnet_ids
}

resource "aws_lb_listener" "lb" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = 200
      content_type = "text/plain"
      message_body = ""
    }
  }
}

### site listener rules

resource "aws_lb_listener_rule" "lb" {
  for_each = var.sites

  listener_arn = aws_lb_listener.lb.arn

  condition {
    host_header {
      values = each.value.hosts
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb[each.key].arn
  }
}

### site target groups

resource "aws_lb_target_group" "lb" {
  for_each = var.sites

  name        = "${var.name}-${each.key}"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lb" {
  depends_on = [aws_lambda_permission.lambda_invoke_by_lb]

  for_each = var.sites

  target_group_arn = aws_lb_target_group.lb[each.key].arn
  target_id        = aws_lambda_function.lambda[each.key].arn
}
