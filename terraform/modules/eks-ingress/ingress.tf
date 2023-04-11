# Creation of service account on EKS
resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = var.service_account
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = var.service_account
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks-workload.arn
    }
  }
}

# Ingress chart to EKS
# TODO Add this to variable condition
resource "helm_release" "ingresschart" {
  name             = "ingresschart"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.6.0"
  wait             = false
}

# ALB chart to EKS
# TODO Add this to variable condition
resource "helm_release" "aws-load-balancer-controller" {
  name       = var.service_account
  chart      = var.service_account
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  wait       = false

  set {
    name  = "clusterName"
    value = var.name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account
  }
}
