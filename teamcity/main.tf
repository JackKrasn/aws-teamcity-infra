locals {
  dataset_name = "s3-dataset"
}

module "teamcity-storage" {
  source              = "./modules/storage"
  s3_bucket           = var.s3_bucket
  s3_artifacts_bucket = var.s3_artifacts_bucket
}

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
  count                     = var.deploy_alb ? 1 : 0
  source                    = "./modules/alb-controller"
  cluster_endpoint          = var.cluster_endpoint
  cluster_name              = var.cluster_name
  eks_certificate_authority = var.eks_certificate_authority
}