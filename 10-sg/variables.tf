variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_description" {
  default = "created sg for frontend instance"
}

variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_description" {
  default = "created sg for bastion instance"
}


variable "mongodb_ports_vpn_ssh" {
  default = [22, 27017]

}

variable "redis_vpn_ssh" {
  default = [22, 6379]

}

variable "mysql_vpn_ssh" {
  default = [22, 3306]
}

# Rabbitmq ports for vpn sg to rabbitmq sg [22,5672]
variable "rabbitmq_vpn_ssh" {
  default = [22, 5672]

}
