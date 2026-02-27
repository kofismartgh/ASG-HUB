resource "aws_security_group" "my_imported_sg" {
    description = "launch-wizard-8 created 2024-07-18T22:07:26.030Z"
    name        = "EC2-sg"
    region      = "us-east-1"
    revoke_rules_on_delete = false
    tags        = {}
    tags_all    = {}
    vpc_id      = "vpc-07539f61"
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all outgoing traffic"
  }
}
