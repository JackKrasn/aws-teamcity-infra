locals {
  common_tags = {
    App    = "s3-storage-teamcity"
    Author = "devops"
  }
}

resource "aws_iam_user" "cluster-user" {
  name = "cluster-user"
  path = "/"
  tags = local.common_tags
}

resource "aws_s3_bucket" "storage-teamcity" {
  bucket = var.s3_bucket
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

module "s3-storage-users" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 3.0"
  name    = "s3-storage-users"

  group_users = ["cluster-user"]

  custom_group_policy_arns = [
    aws_iam_policy.storageTeamcityS3FullAccess.arn
  ]
}

resource "kubernetes_namespace" "dlf" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "dlf"
    }
    name = "dlf"
  }
}

resource "helm_release" "dlf" {
  name             = "dlf"
  chart            = "teamcity/modules/storage/helm-charts/dlf"
  namespace        = "dlf"
  create_namespace = false
  atomic           = true
  wait             = false

  depends_on = [kubernetes_namespace.dlf, aws_s3_bucket.artifacts-storage]
}

# create s3 bucket for artifact storage
resource "aws_s3_bucket" "artifacts-storage" {
  bucket = var.s3_artifacts_bucket
  tags   = local.common_tags
}