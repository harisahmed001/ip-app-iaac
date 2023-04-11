terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
}

variable "name" {
  default     = "ipapp"
  description = "name of the application"
}

variable "instance_eks" {
  default = "t2.small"
}

variable "service_account" {
  default = "aws-load-balancer-controller"
}
