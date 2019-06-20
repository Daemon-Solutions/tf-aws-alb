resource "aws_alb" "alb" {
  count                      = var.enabled ? 1 : 0
  name                       = var.name
  internal                   = var.internal
  security_groups            = var.security_groups
  subnets                    = var.subnets
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    enabled = var.access_logs_enabled
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
  }

  tags = {
    Name        = var.name
    Environment = var.envname
    Service     = var.service
  }
}

module "http_target_group" {
  is_enabled                       = var.enabled && var.enable_http_listener || var.enable_https_listener
  source                           = "./target_group"
  envname                          = var.envname
  service                          = var.service
  target_name                      = var.target_group_name == "" ? "${var.envname}-${var.service}-http-tg" : var.target_group_name
  vpc_id                           = var.vpc_id
  target_port                      = var.target_port
  health_check_port                = var.target_health_check_port
  health_check_path                = var.target_health_check_path
  health_check_matcher             = var.target_health_check_matcher
  health_check_interval            = var.health_check_interval
  health_check_timeout             = var.health_check_timeout
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  stickiness                       = var.http_stickiness
  stickiness_type                  = var.http_stickiness_type
  stickiness_cookie_duration       = var.http_stickiness_cookie_duration
  deregistration_delay             = var.deregistration_delay
}

module "http_listener" {
  is_enabled        = var.enable_http_listener && var.enabled
  source            = "./listener"
  load_balancer_arn = join("", aws_alb.alb.*.arn)
  target_group_arn  = module.http_target_group.alb_target_group_arn
}

module "https_listener" {
  is_enabled               = var.enable_https_listener && var.enabled
  source                   = "./listener"
  listener_port            = "443"
  listener_protocol        = "HTTPS"
  listener_certificate_arn = var.certificate_arn
  listener_ssl_policy      = var.listener_ssl_policy
  load_balancer_arn        = join("", aws_alb.alb.*.arn)
  target_group_arn         = module.http_target_group.alb_target_group_arn
}

