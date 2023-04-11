variable "name" {
  default     = "undefined"
  description = "Name of the resource"
}

variable "password" {
  default     = "hereisthetestpassword"
  description = "Password of user"
}

variable "vpc_id" {
  description = "VPC id for sg"
}

variable "subnet_ids" {
  default     = []
  description = "Subnet ids where rds is created"
}

variable "source_sg" {
  default     = []
  description = "Source sg list"
}
