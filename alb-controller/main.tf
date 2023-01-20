# ALB
# https://www.eksworkshop.com/beginner/130_exposing-service/ingress/
provider "kubectl" {
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
resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("alb-controller/policies-json/alb_iam_policy.json")

}

# This module is roughly equivalent to use the following command in eksctl:
# eksctl create iamserviceaccount \
#   --cluster teamcity-eks-PBfhHx5v \
#   --namespace kube-system \
#   --name aws-load-balancer-controller \
#   --attach-policy-arn arn:aws:iam::079190597294:policy/AWSLoadBalancerControllerIAMPolicy \
#   --override-existing-serviceaccounts \
#   --approve
module "kubernetes-iamserviceaccount" {
  source               = "bigdatabr/kubernetes-iamserviceaccount/aws"
  version              = "1.1.0"
  # insert the 4 required variables here
  cluster_name         = var.cluster_name
  namespace            = "kube-system"
  role_name            = "aws-load-balancer-controller"
  service_account_name = "aws-load-balancer-controller"
  depends_on           = [var.cluster_oidc_url]
}

resource "aws_iam_role_policy_attachment" "attach-policy-alb" {
  role       = module.kubernetes-iamserviceaccount.iam_role.name
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}

resource "kubectl_manifest" "crd" {
  yaml_body = file("alb-controller/manifests/crds.yaml")
}


resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  wait       = false

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

  depends_on = [var.teamcity_release_name]
}