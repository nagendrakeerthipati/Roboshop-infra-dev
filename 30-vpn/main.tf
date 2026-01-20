resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  public_key = file("C:\\Users\\DELL\\Desktop\\devops\\pemfile\\openvpn.pub") # for mac /linux users use file("~/.ssh/openvpn.pub")
}



resource "aws_instance" "vpn" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id              = local.public_subnet_id
  #key_name = openvpn # if it already exist in aws use that name directly else use aws_key_pair.vpn.key_name
  key_name  = awskey_pair.vpn.key_name
  user_data = file("openvpn.sh")

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-vpn"
    }
  )
}
