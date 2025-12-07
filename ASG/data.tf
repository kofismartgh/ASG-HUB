data "aws_launch_template" "main" {
  filter {
    name   = "launch-template-name"
    values = ["${var.service_name}_lt"]
  }
}