variable cluster_name {}
variable cluster_endpoint {}
variable eks_certificate_authority {}
variable teamcity_namespace {}
variable access_key_id {}
variable secret_access_key {}
variable s3_bucket {
  description = "Bucket for TeamCity Data Directory, used by the TeamCity server to store configuration, build results"
}
variable s3_endpoint {
  description = "S3 endpoint"
}
variable s3_artifacts_bucket {
  description = "Bucket for external artifacts storage"
}
variable region {}
variable db_endpoint {}
variable db_port {}
variable db_name {}
variable db_username {}
variable db_password {}
variable deploy_alb {}