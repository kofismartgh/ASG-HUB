resource "aws_security_group_rule" "allowto_access_cybersoucre_stage" {
  type                     = "ingress"
  from_port                = 9000
  to_port                  = 9000
  protocol                 = "tcp"
  source_security_group_id = "sg-07d6266aada845680" #unifiedCheckoutApi 
  description              = "From CheckoutWeb NewCheckoutApi NewCheckoutProxyApi SG to UnifiedCheckout"
  security_group_id        = aws_security_group.my_imported_sg.id
}


resource "aws_security_group_rule" "allowto_access_cybersoucre_stage" {
  type                     = "ingress"
  from_port                = 9000
  to_port                  = 9000
  protocol                 = "tcp"
  source_security_group_id = "sg-0bc98a8efa3587c29" 
  description              = "From RDS  to UnifiedCheckout"
  security_group_id        = aws_security_group.my_imported_sg.id
}
