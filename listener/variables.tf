variable "is_enabled" {
  default = true
}

variable "load_balancer_arn" {
  description = "(Required, Forces New Resource) The ARN of the load balancer."
}

variable "listener_port" {
  description = "(Required) The port on which the load balancer is listening."
  default     = "80"
}

variable "listener_protocol" {
  description = "(Optional) The protocol for connections from clients to the load balancer. Valid values are HTTP and HTTPS. Defaults to HTTP."
  default     = "HTTP"
}

variable "listener_ssl_policy" {
  description = "(Optional) The name of the SSL Policy for the listener. Required if protocol is HTTPS. The only valid value is currently ELBSecurityPolicy-2015-05."
  default     = "ELBSecurityPolicy-2015-05"
}

variable "listener_certificate_arn" {
  description = "(Optional) The ARN of the SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
  default     = ""
}

variable "target_group_arn" {
  description = "(Required) The ARN of the Target Group to which to route traffic."
}

variable "listener_action_type" {
  description = "(Required) The type of routing action. The only valid value is forward."
  default     = "forward"
}
