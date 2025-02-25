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
  default = {
    "main" = {
      name               = "my-vpc"
      cidr               = "10.0.0.0/16"
      availability_zones = ["us-east-1a"]
      public_subnets     = ["10.0.101.0/24"]
      private_subnets    = ["10.0.1.0/24"]
    }
  }
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
  default = {
    "main" = {
      name        = "main-sg"
      description = "Main security group"
      vpc_key     = "main"
      ingress_rules = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          description = "SSH"
          cidr_blocks = "0.0.0.0/0"
        }
      ]
    }
  }
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
  default = {
    "main" = {
      name                        = "instance"
      instance_type               = "t2.micro"
      ami                         = "ami-0c55b159cbfafe1f0"
      key_name                    = "user-key"
      monitoring                  = false
      associate_public_ip_address = true
      iam_instance_profile        = ""
      private_placement           = false
      vpc_key                     = "main"
      security_group_keys         = ["main"]
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
    }
  }
}