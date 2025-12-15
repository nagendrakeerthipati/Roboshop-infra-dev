module "frontend" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id         = local.vpc_id
}


module "bastion" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = local.vpc_id
}

resource "aws_vpc_security_group_rule" "bastion_ingress" {
  security_group_id = module.bastion.sg_id
  type              = "ingress"
  cidr_ipv4         = ["0.0.0.0/0"]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
