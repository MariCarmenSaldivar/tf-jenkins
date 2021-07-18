#Providers

provider "aws" {
  profile = "deep-dive"
  region  = var.region
}

provider "consul" {
  address    = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_datacenter
}

#DATA

data "aws_availability_zones" "available" {}

data "consul_keys" "networking" {
  key {
    name = "networking"
    path = "networking/configuration/globo-primary/net_info"
  }
  key {
    name="common_tags"
    path = "networking/configuration/globo-primary/common_tags"
  }
}

#Locals

locals {
  cidr_block     = jsondecode(data.consul_keys.networking.var.networking)["cidr_block"]
  subnet_count   = jsondecode(data.consul_keys.networking.var.networking)["subnet_count"]
  common_tags = jsondecode(data.consul_keys.networking.var.common_tags)

}
#Resources

#Networking
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "globo-primary"

  cidr            = local.cidr_block
  azs             = slice(data.aws_availability_zones.available.names, 0, local.subnet_count)
  private_subnets = data.template_file.private_cidrsubnet.*.rendered
  public_subnets  = data.template_file.public_cidrsubnet.*.rendered

  enable_nat_gateway = false

  create_database_subnet_group = false

  tags = local.common_tags

}