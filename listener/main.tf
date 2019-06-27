resource "aws_alb_listener" "alb_listener" {
  count             = var.is_enabled ? 1 : 0
  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.listener_certificate_arn != "" ? var.listener_ssl_policy : ""
  certificate_arn   = var.listener_certificate_arn

  default_action {
    target_group_arn = var.target_group_arn
    type             = var.listener_action_type
  }
}

