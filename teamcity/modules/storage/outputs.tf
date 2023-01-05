output "s3_bucket" {
  value = aws_s3_bucket.storage-teamcity.bucket
}

output "s3_artifact_bucket" {
  value = aws_s3_bucket.artifacts-storage.bucket
}