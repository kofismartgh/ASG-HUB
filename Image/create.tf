data "aws_instance" "billing_api_image" {
    #instance_id = "i-061c09e2fe587d6fb" or you can just use the instance id
  filter {
    name   = "tag:Name"
    values = ["Billing-Apis*"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

resource "aws_ami_from_instance" "main" {
  name  = "${var.service_name}_tg_${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"
  source_instance_id = data.aws_instance.billing_api_image.id
  snapshot_without_reboot = true
  tags = {
    Name = "${var.service_name}_tg_${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "ami_id" {
  value = aws_ami_from_instance.main.id
}