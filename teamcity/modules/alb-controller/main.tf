# ALB
# https://www.eksworkshop.com/beginner/130_exposing-service/ingress/
provider "kubectl" {
  apply_retry_count      = 15
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_certificate_authority)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = [
      "eks",
      "get-token",
      "--cluster-name",
      var.cluster_name
    ]
  }
}

module "alb-controller-policy" {
  source                    = "./modules/policy"
  cluster_name              = var.cluster_name
  cluster_endpoint          = var.cluster_endpoint
  eks_certificate_authority = var.eks_certificate_authority
}

resource "kubectl_manifest" "crds" {
  yaml_body = file("teamcity/modules/alb-controller/manifests/crds.yaml")
}

resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "image.tag"
    value = "v2.4.1"
  }

  version   = "1.4.1"
  namespace = "kube-system"

  depends_on = [module.alb-controller-policy]
}