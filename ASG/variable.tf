variable "service_name" {
  description = "Service APIs"
  default     = "Billing-Apis"
}

variable "launch_template_config" {
  description = "Configuration for launch template creation"
  type = object({
    existing_instance_name = string
    is_running_application      = bool
    launch_ami             = string
    instance_type          = string
  })

  default = {
    instance_type          = "t2.micro"
    is_running_application      = false
    launch_ami             = "ami-0fa3fe0fa7920f68e"
    existing_instance_name = "" 
  }

  validation {
    condition = (
      (var.launch_template_config.is_running_application == false ? var.launch_template_config.launch_ami != "" : true) &&
      (var.launch_template_config.is_running_application == true ? var.launch_template_config.existing_instance_name != "" : true)
    )
    error_message = "If step is 'launch_template', then: If is_running_application is set to false, launch_ami must not be empty. If is_running_application is set to true, source_instance_id must not be empty."
  }
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-07539f61"
}


variable "az_token" {
  type    = string
  default = ""
}

variable "az_deploymentgroup" {
  type    = string
  default = "Hub-Api"
}

variable "az_project" {
  type    = string
  default = "Test"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
