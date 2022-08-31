#creating sg
provider "aws" {
  region  = "ap-southeast-1"
}

resource "aws_security_group" "allow_tls" {
  for_each    = var.sg_details
  name        = each.value["name"]
  description = each.value["description"]
  vpc_id      = each.value["vpc_id"]

  dynamic "ingress" {
    for_each = lookup(each.value, "ingress_rules", [])
    content {
      from_port         = lookup(ingress.value, "from_port", null)
      to_port           = lookup(ingress.value, "to_port", null)
      protocol          = lookup(ingress.value, "protocol", null)
      cidr_blocks       = lookup(ingress.value, "cidr_blocks", null)
      self              = lookup(ingress.value, "self", null)
    }

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
