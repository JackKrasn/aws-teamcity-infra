locals {
  dataset_name = "s3-dataset"
}

module "teamcity-storage" {
  source = "./modules/storage"
  s3_bucket = var.s3_bucket
}

#provider "helm" {
#  kubernetes {
#    host                   = var.cluster_endpoint
#    cluster_ca_certificate = base64decode(var.eks_certificate_authority)
#    exec {
#      api_version = "client.authentication.k8s.io/v1beta1"
#      command     = "aws"
#      args        = [
#        "eks",
#        "get-token",
#        "--cluster-name",
#        var.cluster_name
#      ]
#    }
#  }
#}

#module "alb-controller-policy" {
#  source                    = "./modules/alb-controller-policy"
#  cluster_name              = var.cluster_name
#  cluster_endpoint          = var.cluster_endpoint
#  eks_certificate_authority = var.eks_certificate_authority
#}

#resource "kubectl_manifest" "crds" {
#  yaml_body = file("teamcity/yamls/crds.yaml")
#}
#
#resource "helm_release" "aws-load-balancer-controller" {
#  name       = "aws-load-balancer-controller"
#  repository = "https://aws.github.io/eks-charts"
#  chart      = "aws-load-balancer-controller"
#
#  set {
#    name  = "clusterName"
#    value = var.cluster_name
#  }
#
#  set {
#    name  = "serviceAccount.create"w
#    value = false
#  }
#
#  set {
#    name  = "serviceAccount.name"
#    value = "aws-load-balancer-controller"
#  }
#
#  set {
#    name  = "image.tag"
#    value = "v2.4.1"
#  }
#
#  version   = "1.4.1"
#  namespace = "kube-system"
#}

#install teamcity app
resource "helm_release" "teamcity" {
  name             = "teamcity"
  chart            = "teamcity/helm-charts/teamcity"
  namespace        = var.teamcity_namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "teamcity-app.db.endpoint"
    value = var.db_endpoint
  }

  set {
    name  = "teamcity-app.db.port"
    value = var.db_port
  }

  set {
    name  = "teamcity-app.db.name"
    value = var.db_name
  }

  set {
    name  = "teamcity-app.db.username"
    value = var.db_username
  }

  set {
    name  = "teamcity-app.db.password"
    value = var.db_password
  }


  set {
    name  = "teamcity-app.dataset.name"
    value = local.dataset_name
  }

  set {
    name  = "teamcity-app.dataset.aws.accessKeyId"
    value = var.access_key_id
  }

  set {
    name  = "teamcity-app.dataset.aws.secretAccessKeyId"
    value = var.secret_access_key
  }

  set {
    name  = "teamcity-app.dataset.s3.endpoint"
    value = var.s3_endpoint
  }

  set {
    name  = "teamcity-app.dataset.s3.bucket"
    value = var.s3_bucket
  }

  set {
    name  = "teamcity-app.dataset.aws.region"
    value = var.region
  }

  set {
    name  = "teamcity-app.pvc.server.name"
    value = local.dataset_name
  }

  depends_on = [module.teamcity-storage]
}

module "alb-controller" {
  source = "./modules/alb-controller"
  cluster_endpoint = var.cluster_endpoint
  cluster_name = var.cluster_name
  eks_certificate_authority = var.eks_certificate_authority
}