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
  atomic           = false
  timeout = 600

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

module "ebs" {
  source = "./modules/ebs"
  node_group_1_role = var.eks_managed_node_groups["one"]["iam_role_name"]
  node_group_2_role = var.eks_managed_node_groups["two"]["iam_role_name"]
}