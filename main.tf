provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.eks_certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks-cluster.cluster_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks-cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks-cluster.eks_certificate_authority)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks-cluster.cluster_name
      ]
    }
  }
}

module "eks-cluster" {
  source               = "./eks-cluster"
  region               = var.region
  database_subnets     = var.database_subnets
  node_private_subnets = var.node_private_subnets
}

module "rds" {
  source               = "./rds"
  identifier           = var.identifier
  db_name              = var.db_name
  storage_type         = var.storage_type
  allocated_storage    = var.allocated_storage
  db_engine            = var.db_engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  db_subnet_group_name = module.eks-cluster.database_subnet_group_name
  region               = var.region
  vpc_id               = module.eks-cluster.vpc_id
  node_private_subnets = var.node_private_subnets
  db_master_password   = var.db_master_password
  db_master_username   = "Admin"
}

module "teamcity" {
  count                     = var.deploy_teamcity ? 1 : 0
  source                    = "./teamcity"
  cluster_name              = module.eks-cluster.cluster_name
  cluster_endpoint          = module.eks-cluster.cluster_endpoint
  eks_certificate_authority = module.eks-cluster.eks_certificate_authority
  s3_artifacts_bucket       = "teamcity-art-bucket"
  teamcity_namespace        = "teamcity"
  db_endpoint               = module.rds.db_cluster_endpoint
  db_name                   = var.db_name
  db_password               = var.db_password
  db_port                   = module.rds.db_cluster_port
  db_username               = var.db_username
  deploy_alb                = var.deploy_alb
  node_group_1_role         = module.eks-cluster.eks_managed_node_groups["one"]["iam_role_name"]
  node_group_2_role         = module.eks-cluster.eks_managed_node_groups["two"]["iam_role_name"]
}
