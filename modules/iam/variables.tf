### REGION ###

variable "region" {
  type = string
  default = "us-west-2"
  description = "AWS Region to launch resources"
}

### IAM ROLE VARIABLES ###

variable "iam_role_pipeline_name" {
  type = string
  description = "Name for the IAM role for the Codepipeline Role."
}

variable "iam_role_codebuild_name" {
  type = string
  description = "Name for the IAM role for Codebuilde role"  
}

### IAM POLICY VARIABLES ###

variable "iam_pipeline_name" {
  type = string
  description = "Name for the IAM policy for the Pipeline"
}

variable "iam_build_name" {
  type = string
  description = "Name for the IAM policy for the Codebuild Policy"
}

# variable "iam_pipeline_policy" {
#   type = string
#   default = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
#   description = "The policy document for the Pipeline IAM Policy."
# }

# variable "iam_codebuild_policy" {
#   type = string
#   default = data.aws_iam_policy_document.tf-cicd-build-policies.json
#   description = "The policy document for the Codebuild IAM policy"
# }


# variable "iam_arn" {
#   type = string
#   default = null
#   description = "If you have preexisting IAM roles you can import them by providing the ARN."
# }