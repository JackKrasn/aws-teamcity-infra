locals {
  common_tags = {
    App    = "s3-storage-teamcity"
    Author = "devops"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_certificate_authority)
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
}

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

resource "aws_iam_user" "cluster-user" {
  name = "cluster-user"
  path = "/"
  tags = local.common_tags
}
module "s3-storage-users" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 3.0"
  name    = "s3-storage-users"

  group_users = ["cluster-user"]

  custom_group_policy_arns = [
    aws_iam_policy.storageTeamcityS3FullAccess.arn
  ]
}

resource "aws_s3_bucket" "storage-teamcity" {
  bucket = "storage-teamcity"
  tags   = local.common_tags
}

resource "aws_iam_policy" "storageTeamcityS3FullAccess" {
  name        = "storageTestS3FullAccess"
  path        = "/"
  description = "Allow full access to storage-teamcity s3"
  tags        = local.common_tags
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:PutAccountPublicAccessBlock",
        "s3:GetAccountPublicAccessBlock",
        "s3:ListAllMyBuckets",
        "s3:ListJobs",
        "s3:CreateJob",
        "s3:HeadBucket",
        "s3:ListBucket"
      ],
      "Resource": "*"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::storage-teamcity",
        "arn:aws:s3:::storage-teamcity/*"
      ]
    }
  ]
}
POLICY
}

# ALB
# https://www.eksworkshop.com/beginner/130_exposing-service/ingress/
module "alb-controller-policy" {
  source                    = "./modules/alb-controller-policy"
  cluster_name              = var.cluster_name
  cluster_endpoint          = var.cluster_endpoint
  eks_certificate_authority = var.eks_certificate_authority
}

resource "kubectl_manifest" "crds" {
  yaml_body = file("teamcity/yamls/crds.yaml")
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

  version = "1.4.1"
  namespace = "kube-system"
}

