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

module "backend_alb" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "backend-alb"
  sg_description = "for backend alb"
  vpc_id         = local.vpc_id
}

#for OpenVpn
module "vpn" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "vpn"
  sg_description = "vpn sg"
  vpc_id         = local.vpc_id
}

#for databases security groups
module "mongodb" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "mongodb"
  sg_description = "for mongodb sg"
  vpc_id         = local.vpc_id
}

module "redis" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "redis"
  sg_description = "for redis sg"
  vpc_id         = local.vpc_id
}

module "mysql" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "mysql"
  sg_description = "for mysql sg"
  vpc_id         = local.vpc_id
}

module "rabbitmq" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "rabbitmq"
  sg_description = "for rabbitmq sg"
  vpc_id         = local.vpc_id
}


module "catalogue" {
  #source = "../../terraform-aws-securitygroup"
  source      = "git::https://github.com/nagendrakeerthipati/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "catalogue"
  sg_description = "for catalogue sg"
  vpc_id         = local.vpc_id
}



# bastion accepting from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}


# backend ALB accepting  connections from my bastion host on port n0 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  #cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id

}

# vpn port for  22, 443,1194,943  

resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_http" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}


# backend ALB accepting  connections from my vpn   host on port n0 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  # cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# mongodb ports for vpn sg to mongodb sg [22,27017]
resource "aws_security_group_rule" "mongodb_ports_vpn_ssh" {
  count                    = length(var.mongodb_ports_vpn_ssh)
  type                     = "ingress"
  from_port                = var.mongodb_ports_vpn_ssh[count.index]
  to_port                  = var.mongodb_ports_vpn_ssh[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id

}

# redis port for vpn sg to redis sg [22,6379]
resource "aws_security_group_rule" "redis_vpn_ssh" {
  count                    = length(var.redis_vpn_ssh)
  type                     = "ingress"
  from_port                = var.redis_vpn_ssh[count.index]
  to_port                  = var.redis_vpn_ssh[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id

}

# mysql port for vpn sg to mysql sg [22,3306]
resource "aws_security_group_rule" "mysql_vpn_ssh" {
  count                    = length(var.mysql_vpn_ssh)
  type                     = "ingress"
  from_port                = var.mysql_vpn_ssh[count.index]
  to_port                  = var.mysql_vpn_ssh[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id

}

# rabbitmq port for vpn sg to rabbitmq sg[22,5672]
resource "aws_security_group_rule" "rabbitmq_vpn_ssh" {
  count                    = length(var.rabbitmq_vpn_ssh)
  type                     = "ingress"
  from_port                = var.rabbitmq_vpn_ssh[count.index]
  to_port                  = var.rabbitmq_vpn_ssh[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id

}


# catalogue service port 8080  from catalogue sg to backend alb sg
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type      = "ingress"
  from_port = 8080
  to_port   = 8080
  protocol  = "tcp"
  # cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.catalogue.sg_id
}


resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}


resource "aws_security_group_rule" "catalogue_vpn_http" {
  type      = "ingress"
  from_port = 8080
  to_port   = 8080
  protocol  = "tcp"

  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}

#catalogue to bastion ssh
resource "aws_security_group_rule" "catalogue_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.catalogue.sg_id

}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id        = module.mongodb.sg_id

}
