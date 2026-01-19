module "backend_alb" {
  source   = "terraform-aws-modules/alb/aws"
  version  = "v10.4.0"
  internal = true

  name                  = "${var.project}-${var.environment}-backend-alb" #roboshop-dev-backend-alb
  vpc_id                = local.vpc_id.value
  subnets               = local.private_subnet_ids
  create_security_group = false
  security_groups       = [local.backend_alb_sg_id] #list it should be error 



  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-backend-alb"
    }
  )
}


resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = module.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Backend ALB is working</h1>"
      status_code  = "200"
    }
  }
}
