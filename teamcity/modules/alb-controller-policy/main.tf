resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("teamcity/modules/alb-controller-policy/policies-json/alb_iam_policy.json")

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
}

resource "aws_iam_role_policy_attachment" "attach-policy-alb" {
  role       = module.kubernetes-iamserviceaccount.iam_role.name
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}