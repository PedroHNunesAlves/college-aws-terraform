region = "us-east-1"

vpcs = {
  "dev-vpc-1" = {
    name               = "dev-vpc-1"
    cidr               = "10.0.0.0/16"
    availability_zones = ["us-east-1a"]
    public_subnets     = ["10.0.101.0/24"]
    private_subnets    = ["10.0.1.0/24"]
  }
}

security_groups = {
  "web-sg" = {
    name        = "web-sg"
    description = "Security Group for web application"
    vpc_key     = "dev-vpc-1"
    ingress_rules = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        description = "SSH port"
        cidr_blocks = "10.0.0.0/32"
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        description = "HTTPS"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        description = "HTTP"
        cidr_blocks = "0.0.0.0/0"
      }
    ]
  }
}

ec2_instances = {
  "web-server-1" = {
    name                        = "web-server-1"
    instance_type               = "t2.micro"
    ami                         = "ami-0c55b159cbfafe1f0"
    key_name                    = "pnunes-key"
    monitoring                  = false
    associate_public_ip_address = true
    iam_instance_profile        = "dev-ec2-profile"
    private_placement           = false
    vpc_key                     = "dev-vpc-1"
    security_group_keys         = ["web-sg"]
    root_block_device = {
      volume_size = 10
      volume_type = "gp2"
    }
  },
  "web-server-2" = {
    name                        = "web-server-2"
    instance_type               = "t2.micro"
    ami                         = "ami-0c55b159cbfafe1f0"
    key_name                    = "pnunes-key"
    monitoring                  = false
    associate_public_ip_address = true
    iam_instance_profile        = "dev-ec2-profile"
    private_placement           = false
    vpc_key                     = "dev-vpc-1"
    security_group_keys         = ["web-sg"]
    root_block_device = {
      volume_size = 10
      volume_type = "gp2"
    }
  }
}