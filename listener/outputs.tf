# Outputs
# id - The ARN of the listener (matches arn)
# arn - The ARN of the listener (matches id)

output "alb_listener_id" {
  value = "${element(concat(aws_alb_listener.alb_listener.*.id, list("")), 0)}"
}

output "alb_listener_arn" {
  value = "${element(concat(aws_alb_listener.alb_listener.*.arn, list("")), 0)}"
}
