variable "region" {
  default = "us-east-1"
}

variable "consul_address" {
  type        = string
  description = "Address of Consul server"
  default     = "localhost"
}

variable "consul_port" {
  type        = number
  description = "Port Consul server is listening on"
  default     = "8500"
}

variable "consul_datacenter" {
  type        = string
  description = "Name of the Consul Datacenter"
  default     = "dc1"
}

# variable "subnet_count" {
#   default = 2
# }

# variable "cidr_block" {
#   default = "10.0.0.0/16"
# }

# variable "private_subnets" {
#   type = list(any)
# }

# variable "public_subnets" {
#   type = list(any)
# }