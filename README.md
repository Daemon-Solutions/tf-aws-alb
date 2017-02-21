tf-aws-alb
==========

AWS Application Load-Balancer (ALB) - Terraform Module

Usage
-----

```js
provider "aws" {
 region     = "eu-west-2"
}

module "alb" {
   source = "../modules/tf-aws-alb"
   envname = "dev"
   envtype = "nonprod"
   service = "test"
   name = "test"
   subnets = ["subnet-51353829", "subnet-e65d70ac"]
   security_groups = ["sg-2d4ba744"]
   enable_http_listener = true
   enable_https_listener = true
   vpc_id = "${var.vpc_id}"
   certificate_arn = "arn:aws:acm:eu-west-2:1234567890:certificate/0d549bc3-17c2-4124-82e4-8dcd2d58fe8a"

}

module "target_group" {
   source = "../dev/bashton/repos/tf-aws-alb/target_group"
   envname = "dev"
   envtype = "nonprod"
   service = "test"
   target_name  = "tg-8080"
   target_port = "8080"
   vpc_id = "${var.vpc_id}"
   stickiness  = true
   health_check_path = "/status"
}


module "listener" {
   source = "../dev/bashton/repos/tf-aws-alb/listener"
   load_balancer_arn = "${module.alb.alb_arn}"
   listener_port = "8080"
   target_group_arn = "${module.target_group.alb_target_group_arn}"
}

output "default_target_group_arn" {
  value = "${module.alb.default_target_group_arn}"
}
```

Variables
---------

 - `name` - Name of the ALB

Outputs
-------

