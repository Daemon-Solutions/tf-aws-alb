# Outputs
# id - The ARN of the listener (matches arn)
# arn - The ARN of the listener (matches id)

output "alb_listener_id" {
  value = "${aws_alb_listener.alb_listener.id}"
}

output "alb_listener_arn" {
  value = "${aws_alb_listener.alb_listener.arn}"
}
