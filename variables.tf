variable "envname" {}
variable "envtype" {}
variable "service" {}

variable "name" {
  description = "The name of the ALB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. If not specified, Terraform will autogenerate a name beginning with tf-lb."
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  default     = ""
}

variable "internal" {
  description = "If true, the ALB will be internal"
  default     = false
}

variable "security_groups" {
  type        = "list"
  description = "A list of security group IDs to assign to the LB"
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB"
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Default: 60"
  default     = "60"
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false"
  default     = false
}

variable "access_logs" {
  description = "If true, enables an access logs"
}

variable "access_logs_bucket" {
  description = "The S3 bucket name to store the logs in. Valid only if access_logs is set to true"
  default     = "None"
}

variable "access_logs_bucket_prefix" {
  description = "The S3 bucket prefix. Logs are stored in the root if not configured"
  default     = "/"
}

# ----------------------------------------
# Target group variables
# ----------------------------------------
variable "target_name" {
  description = "(Required) The name of the target group."
}

variable "target_port" {
  description = "(Required) The port on which targets receive traffic, unless overridden when registering a specific target."
  default     = "80"
}

variable "target_protocol" {
  description = "(Required) The protocol to use for routing traffic to the targets."
  default     = "HTTP"
}

variable "vpc_id" {
  description = "(Required) The identifier of the VPC in which to create the target group."
}

variable "deregistration_delay" {
  description = "(Optional) The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
  default     = "300"
}

## Stickiness variables
variable "stickiness" {
  description = "(Optional) If true, enables stickiness"
  default     = false
}

variable "stickiness_type" {
  description = "(Required) The type of sticky sessions. The only current possible value is lb_cookie."
  default     = "lb_cookie"
}

variable "stickiness_cookie_duration" {
  description = "(Optional) The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds)."
  default     = "86400"
}

## Health check variables
variable "health_check_interval" {
  description = "(Optional) The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
  default     = "30"
}

variable "health_check_path" {
  description = "(Optional) The destination for the health check request. Default /."
  default     = "/"
}

variable "health_check_port" {
  description = "(Optional) The port to use to connect with the target. Valid values are either ports 1-65536, or traffic-port. Defaults to traffic-port."
  default     = "80"
}

variable "health_check_protocol" {
  description = "(Optional) The protocol to use to connect with the target. Defaults to HTTP."
  default     = "HTTP"
}

variable "health_check_timeout" {
  description = "(Optional) The amount of time, in seconds, during which no response means a failed health check. Defaults to 5 seconds."
  default     = "5"
}

variable "health_check_healthy_threshold" {
  description = "(Optional) The number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 5."
  default     = "5"
}

variable "health_check_unhealthy_threshold" {
  description = "(Optional) The number of consecutive health check failures required before considering the target unhealthy. Defaults to 2."
  default     = "2"
}

variable "health_check_matcher" {
  description = "(Optional) The HTTP codes to use when checking for a successful response from a target. Defaults to 200. You can specify multiple values (for example, \"200,202\") or a range of values (for example, \"200-299\")."
  default     = "200"
}
