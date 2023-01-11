locals {
  dataset_name = "s3-dataset"
}

#s3-storage for artifacts
resource "aws_s3_bucket" "artifacts-storage" {
  bucket = var.s3_artifacts_bucket
}

#install teamcity app
resource "helm_release" "teamcity" {
  name             = "teamcity"
  chart            = "teamcity/helm-charts/teamcity"
  namespace        = var.teamcity_namespace
  create_namespace = true
  atomic           = true

  set {
    name  = "db.endpoint"
    value = var.db_endpoint
  }

  set {
    name  = "db.port"
    value = var.db_port
  }

  set {
    name  = "db.name"
    value = var.db_name
  }

  set {
    name  = "db.username"
    value = var.db_username
  }

  set {
    name  = "db.password"
    value = var.db_password
  }

  depends_on = [module.ebs]
}

module "alb-controller" {
  count                     = var.deploy_alb ? 1 : 0
  source                    = "./modules/alb-controller"
  cluster_endpoint          = var.cluster_endpoint
  cluster_name              = var.cluster_name
  eks_certificate_authority = var.eks_certificate_authority
}

module "ebs" {
  source = "modules/ebs"
  node_group_1_role = var.node_group_1_role
  node_group_2_role = var.node_group_2_role
}