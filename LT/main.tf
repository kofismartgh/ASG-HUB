data "aws_instances" "existing_instance" {
  count = var.launch_template_config.is_running_application ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.launch_template_config.existing_instance_name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instance" "existing_instance_id" {
  count = var.launch_template_config.is_running_application ? 1 : 0

  instance_id = data.aws_instances.existing_instance[0].ids[0]
}

resource "aws_ami_from_instance" "main" {
  count = var.launch_template_config.is_running_application ? 1 : 0
  name  = "${var.service_name}_tg_${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"

  source_instance_id      = data.aws_instance.existing_instance_id[0].id
  snapshot_without_reboot = true
  tags = {
    Name = "${var.service_name}_tg_${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"
  }
  lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_launch_template" "main" {
  name = "${var.service_name}_lt"

  iam_instance_profile {
    name = "ec2ssmrole" 
    
  }

  metadata_options {
    http_tokens = "required"
  }

  update_default_version = true
  description            = "${var.service_name}_lt, Created on ${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"

  image_id      = var.launch_template_config.is_running_application ? aws_ami_from_instance.main[0].id : var.launch_template_config.launch_ami
  instance_type = var.launch_template_config.instance_type
  user_data     = base64encode(templatefile("install_prerequisites.sh", { az_token = var.az_token, az_deploymentgroup = var.az_deploymentgroup, az_project = var.az_project }))
  placement {
    availability_zone = "eu-west-1a,eu-west-1b,eu-west-1c"
  }

  vpc_security_group_ids = [
    "sg-0f3bbadc059e1ebce"
  ]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size           = 10
      volume_type           = "standard"
    }
  }

  tags = {
      Name = "${var.service_name}_asg_launch_template-${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"
    }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.service_name}_asg_launch_template-${formatdate("YYYY-MM-DD_hh-mm", timestamp())}"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

