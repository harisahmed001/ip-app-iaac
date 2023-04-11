module "vpc" {
  source = "../modules/vpc"
  name   = var.name
  cidr   = "10.0.0.0/16"

  az_public  = ["us-east-1a", "us-east-1b"]
  az_private = ["us-east-1c", "us-east-1d"]

  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway      = true
  enable_ec2_vpc_endpoint = true

  tags = {
    Terraform   = "true"
    Environment = "Production"
  }
}

module "ecr" {
  source = "../modules/ecr"
  #name   = var.name
}

module "rds" {
  source     = "../modules/rds"
  name       = var.name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  source_sg  = [module.eks.cluster_primary_security_group_id]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.name
  cluster_version = "1.25"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_enabled_log_types   = []
  create_kms_key              = false
  cluster_encryption_config   = {}
  create_cloudwatch_log_group = false
}

module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name                              = "${var.name}-node-group"
  cluster_name                      = module.eks.cluster_name
  cluster_version                   = module.eks.cluster_version
  subnet_ids                        = module.vpc.private_subnets
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id

  min_size     = 1
  max_size     = 2
  desired_size = 1

  instance_types = [var.instance_eks]
  capacity_type  = "ON_DEMAND"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.name]
      command     = "aws"
    }
  }
}

module "eks-ingress" {
  source = "../modules/eks-ingress"
  name   = var.name
  eks    = module.eks
}
