resource "aws_iam_policy" "eks_worknode_ebs_policy" {
  name = "Amazon_EBS_CSI_Driver"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
# And attach the new policy
resource "aws_iam_role_policy_attachment" "worknode1-AmazonEBSCSIDriver" {
  policy_arn = aws_iam_policy.eks_worknode_ebs_policy.arn
  role       = var.node_group_1_role
}

resource "aws_iam_role_policy_attachment" "worknode2-AmazonEBSCSIDriver" {
  policy_arn = aws_iam_policy.eks_worknode_ebs_policy.arn
  role       = var.node_group_2_role
}

resource "helm_release" "aws-ebs-csi-driver" {
  name             = "aws-ebs-csi-driver"
  chart            = "teamcity/modules/elb/helm-charts/aws-ebs-csi-driver"
  namespace        = "kube-system"
  create_namespace = false
  atomic           = true
}
