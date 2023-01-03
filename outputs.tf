output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks-cluster.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks-cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks-cluster.cluster_security_group_id
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks-cluster.cluster_name
}

output "vpc_name" {
  description = "EKS vpc name"
  value       = module.eks-cluster.vpc_name
}

output "vpc_id" {
  description = "VPC id"
  value       = module.eks-cluster.vpc_id
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.eks-cluster.database_subnets
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = module.eks-cluster.database_subnet_arns
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.eks-cluster.database_subnets_cidr_blocks
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.eks-cluster.database_subnet_group
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.eks-cluster.database_subnet_group_name
}

output "database_identifier" {
  value = var.identifier
}

output "database" {
  value = ""
}

output "cluster_iam_role_name" {
  value = module.eks-cluster.cluster_iam_role_name
}

output "db_cluster_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_cluster_endpoint
}

output "db_cluster_port" {
  description = "The cluster db port"
  value       = module.rds.db_cluster_port
}

output "secret_arn" {
  description = "The secret arn with db credentials"
  value       = module.rds.secret_arn
}

output "db_username" {
  description = "db admin user"
  value       = var.db_username
}

output "db_password" {
  description = "password, provide through your tfvars file"
  value       = var.db_password
}

output "db_name" {
  description = "database name"
  value       = var.db_name
}

output "region" {
  value = var.region
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks-cluster.cluster_oidc_issuer_url
}

