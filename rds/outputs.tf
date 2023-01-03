output "db_cluster_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_rds_cluster.cluster.arn, "")
}

output "db_cluster_endpoint" {
  description = "The connection endpoint"
  value       = try(aws_rds_cluster.cluster.endpoint, "")
}

output "db_cluster_engine" {
  description = "The database engine"
  value       = try(aws_rds_cluster.cluster.engine, "")
}

output "db_cluster_engine_version_actual" {
  description = "The running version of the database"
  value       = try(aws_rds_cluster.cluster.engine_version_actual, "")
}

output "db_cluster_name" {
  description = "The database name"
  value       = try(aws_rds_cluster.cluster.database_name, "")
}

output "db_cluster_port" {
  description = "The database port"
  value       = try(aws_rds_cluster.cluster.port, "")
}

output "secret_arn" {
  value = aws_secretsmanager_secret_version.db-pass-val.secret_id
}