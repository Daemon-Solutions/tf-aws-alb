module "alb" {
  source                      = "../.."
  envname                     = "dev"
  service                     = "test"
  name                        = "test"
  subnets                     = module.vpc.public_subnet_ids
  security_groups             = [aws_security_group.allow_all.id]
  enable_http_listener        = true
  enable_https_listener       = false
  vpc_id                      = module.vpc.vpc_id
  access_logs_bucket          = aws_s3_bucket.log_bucket.id
  access_logs_prefix          = "alb_logs"
  http_stickiness             = true
  target_health_check_path    = "/healthcheck.php"
  target_health_check_port    = "80"
  target_health_check_matcher = "200,302"
}

module "target_group" {
  source            = "../../target_group"
  envname           = "dev"
  service           = "test"
  target_name       = "tg-8080"
  target_port       = "8080"
  vpc_id            = module.vpc.vpc_id
  stickiness        = true
  health_check_path = "/status"
}

module "listener" {
  source            = "../../listener"
  load_balancer_arn = module.alb.alb_arn
  listener_port     = "8080"
  target_group_arn  = module.target_group.alb_target_group_arn
}

output "default_target_group_arn" {
  value = module.alb.default_target_group_arn
}

