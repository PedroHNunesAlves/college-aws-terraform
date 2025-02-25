variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpcs" {
  type = map(object({
    name               = string
    cidr               = string
    availability_zones = list(string)
    public_subnets     = list(string)
    private_subnets    = list(string)
  }))
}

variable "security_groups" {
  type = map(object({
    name        = string
    description = string
    vpc_key     = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
      cidr_blocks = string
    }))
  }))
}

variable "ec2_instances" {
  type = map(object({
    name                        = string
    instance_type               = string
    ami                         = string
    key_name                    = string
    monitoring                  = bool
    associate_public_ip_address = bool
    iam_instance_profile        = string
    private_placement           = bool
    vpc_key                     = string
    security_group_keys         = list(string)
    root_block_device = object({
      volume_size = number
      volume_type = string
    })
  }))
}