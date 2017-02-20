resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${var.load_balancer_arn}"
  port              = "${var.listener_port}"
  protocol          = "${var.listener_protocol}"
  ssl_policy        = "${var.ssl_policy}"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${var.target_group_arn}"
    type             = "${var.listener_action_type}"
  }
}
