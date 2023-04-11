variable "name" {
  default     = "undefined"
  description = "Name of the resource"
}

variable "eks" {
  description = "EKS object"
}

variable "service_account" {
  default     = "aws-load-balancer-controller"
  description = "Service account name to be created"
}
