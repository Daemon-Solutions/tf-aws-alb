# Outputs

// The name of the load balancer.
output "alb_name" {
  value = "${join("", aws_alb.alb.*.name)}"
}

// The ARN of the load balancer (matches arn).
output "alb_id" {
  value = "${join("", aws_alb.alb.*.id)}"
}

// The ARN of the load balancer (matches id).
output "alb_arn" {
  value = "${join("", aws_alb.alb.*.arn)}"
}

// The ARN suffix for use with CloudWatch Metrics.
output "alb_arn_suffix" {
  value = "${join("", aws_alb.alb.*.arn_suffix)}"
}

// The DNS name of the load balancer.
output "alb_dns_name" {
  value = "${join("", aws_alb.alb.*.dns_name)}"
}

// The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record).
output "alb_zone_id" {
  value = "${join("", aws_alb.alb.*.zone_id)}"
}

// ARN for the default target group
output "default_target_group_arn" {
  value = "${module.http_target_group.alb_target_group_arn}"
}

// The ARN suffix for use with CloudWatch Metrics.
output "default_target_group_arn_suffix" {
  value = "${module.http_target_group.alb_target_group_arn_suffix}"
}

// ARN for the default HTTP listener
output "default_http_listener_arn" {
  value = "${module.http_listener.alb_listener_arn}"
}

// ARN for the default HTTPS listener
output "default_https_listener_arn" {
  value = "${module.https_listener.alb_listener_arn}"
}
