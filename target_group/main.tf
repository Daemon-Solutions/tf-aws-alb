resource "aws_alb_target_group" "alb_target_group" {
  name     = "${var.target_name}"
  port     = "${var.target_port}"
  protocol = "${var.target_protocol}"
  vpc_id   = "${var.vpc_id}"

  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    port                = "${var.health_check_port}"
    protocol            = "${var.health_check_protocol}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    matcher             = "${var.health_check_matcher}"
  }

  stickiness {
    enabled         = "${var.stickiness}"
    type            = "${var.stickiness_type}"
    cookie_duration = "${var.stickiness_cookie_duration}"
  }

  tags {
    Name        = "${var.target_name}"
    Environment = "${var.envname}"
    Service     = "${var.service}"
  }
}
