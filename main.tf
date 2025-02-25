module "network" {
  for_each = var.vpcs
  source   = "./modules/network"
  
  vpc_name           = each.value.name
  vpc_cidr           = each.value.cidr
  availability_zones = each.value.availability_zones
  public_subnets     = each.value.public_subnets
  private_subnets    = each.value.private_subnets
  
  tags = merge(local.common_tags, {
    "VPC" = each.value.name
  })
}

module "security_group" {
  for_each = var.security_groups
  source   = "./modules/security-group"
  
  name        = each.value.name
  description = each.value.description
  vpc_id      = module.network[each.value.vpc_key].vpc_id
  vpc_cidr    = var.vpcs[each.value.vpc_key].cidr
  ingress_rules = each.value.ingress_rules
  
  tags = merge(local.common_tags, {
    "VPC" = var.vpcs[each.value.vpc_key].name
  })
  
  depends_on = [
    module.network
  ]
}

module "ec2_instance" {
  for_each = var.ec2_instances
  source   = "./modules/ec2"
  
  name               = each.value.name
  ami                = each.value.ami
  instance_type      = each.value.instance_type
  key_name           = each.value.key_name
  monitoring         = each.value.monitoring
  iam_instance_profile = each.value.iam_instance_profile
  
  subnet_id          = each.value.private_placement ? module.network[each.value.vpc_key].private_subnet_ids[0] : module.network[each.value.vpc_key].public_subnet_ids[0]
  security_group_ids = [for sg_key in each.value.security_group_keys : module.security_group[sg_key].security_group_id]
  associate_public_ip = each.value.private_placement ? false : each.value.associate_public_ip_address
  
  root_volume_size   = each.value.root_block_device.volume_size
  root_volume_type   = each.value.root_block_device.volume_type
  
  tags = merge(local.common_tags, {
    "Name" = each.value.name,
    "VPC"  = var.vpcs[each.value.vpc_key].name
  })
  
  depends_on = [
    module.network,
    module.security_group
  ]
}