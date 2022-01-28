output "iam_tf_cicd_pipeline_policy_arn" {
  value = aws_iam_policy.tf_cicd_pipeline_policy.arn
  description = "The ARN assigned by AWS to the Codepipeline IAM Policy"
}

output "iam_tf_cicd_build_arn" {
  value = aws_iam_policy.tf_cicd_build_policy.arn
  description = "The ARN assigned by AWS to the Codebuild IAM Policy"
}

output "tf_codebuild_role" {
  value = aws_iam_role.tf_codebuild_role.arn
  description = "ARN of TF Codebuild role"
}

output "codepipeline_role" {
  value = aws_iam_role.codepipeline_role.arn
  description = "The ARN assigned by AWS to Codepipeline IAM Policy"
}