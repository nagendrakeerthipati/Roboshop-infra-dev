
# MongoDB Instance
resource "aws_instance" "mongodb" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mongodb"
    }
  )
}

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
  provisioner "file" {
    source      = "bootstrap.sh" #copy from local to remote  and bootstrap--> is just name in general we use it for config scripts
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo /tmp/bootstrap.sh mongodb ${var.environment}"
    ]

  }

}

# Redis Instance
resource "aws_instance" "redis" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-redis"
    }
  )
}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo /tmp/bootstrap.sh redis ${var.environment}"
    ]
  }
}

# MySQL Instance
resource "aws_instance" "mysql" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_id
  iam_instance_profile   = "EC2RoleToFetchssmparameters"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mysql"
    }
  )
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}
# RabbitMQ Instance
resource "aws_instance" "rabbitmq" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-rabbitmq"
    }
  )
}
resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo /tmp/bootstrap.sh rabbitmq ${var.environment}"
    ]
  }
}

# mongodb Route53 Record
resource "aws_route53_record" "mongodb" {
  zone_id         = var.zone_id
  name            = "mongodb.${var.zone_name}"
  type            = "A"
  ttl             = 1
  allow_overwrite = true
  records         = [aws_instance.mongodb.private_ip] #assigning private ip of mongodb instance(database) to this record

}

# redis Route53 Record
resource "aws_route53_record" "redis" {
  zone_id         = var.zone_id
  name            = "redis.${var.zone_name}"
  type            = "A"
  ttl             = 1
  allow_overwrite = true
  records         = [aws_instance.redis.private_ip] #assigning private ip of redis instance(database) to this record

}

# mysql Route53 Record
resource "aws_route53_record" "mysql" {
  zone_id         = var.zone_id
  name            = "mysql.${var.zone_name}"
  type            = "A"
  ttl             = 1
  allow_overwrite = true
  records         = [aws_instance.mysql.private_ip] #assigning private ip of mysql instance(database) to this record

}

# rabbitmq Route53 Record
resource "aws_route53_record" "rabbitmq" {
  zone_id         = var.zone_id
  name            = "rabbitmq.${var.zone_name}"
  type            = "A"
  ttl             = 1
  allow_overwrite = true
  records         = [aws_instance.rabbitmq.private_ip] #assigning private ip of rabbitmq instance(database) to this record

}
