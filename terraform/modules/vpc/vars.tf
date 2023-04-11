variable "name" {
  default     = "undefined"
  description = "Name of the resource"
}

variable "cidr" {
  default     = "10.0.0.0/16"
  description = "#TODO"
}

variable "private_subnets" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "#TODO"
}

variable "public_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "az_public" {
  default     = ["us-east-1a", "us-east-1b"]
  description = "#TODO"
}

variable "az_private" {
  default     = ["us-east-1c", "us-east-1d"]
  description = "#TODO"
}

variable "enable_nat_gateway" {
  default     = false
  description = "#TODO"
}

variable "enable_ec2_vpc_endpoint" {
  default     = false
  description = "#TODO"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "#TODO"
}
