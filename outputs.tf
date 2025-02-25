output "vpc_ids" {
  value = {
    for k, v in module.network : k => v.vpc_id
  }
}

output "private_subnet_ids" {
  value = {
    for k, v in module.network : k => v.private_subnet_ids
  }
}

output "public_subnet_ids" {
  value = {
    for k, v in module.network : k => v.public_subnet_ids
  }
}

output "security_group_ids" {
  value = {
    for k, v in module.security_group : k => v.security_group_id
  }
}

output "ec2_instance_ids" {
  value = {
    for k, v in module.ec2_instance : k => v.instance_id
  }
}

output "ec2_private_ips" {
  value = {
    for k, v in module.ec2_instance : k => v.private_ip
  }
}

output "ec2_public_ips" {
  value = {
    for k, v in module.ec2_instance : k => v.public_ip
  }
}