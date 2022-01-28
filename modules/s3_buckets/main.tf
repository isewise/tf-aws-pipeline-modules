provider "aws" {
  region = var.s3_region
}

### S3 BUCKET FOR TF REMOTE BACKEND ###

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "terraform-cicd-project-${random_integer.s3_bucket_appendix.id}"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

### S3 BUCKET FOR CODEPIPELINE ARTIFACTS ###

resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "cicd-pipeline-artifacts-${random_integer.s3_pipeline_appendix.id}"
  acl    = "private"
}