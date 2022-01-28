output "pipeline_artifact" {
  value = aws_s3_bucket.codepipeline_artifacts.id
}

output "remote_state_bucket" {
  value = aws_s3_bucket.s3_bucket.id
}