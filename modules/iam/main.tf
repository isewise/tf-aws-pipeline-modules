provider "aws" {
  region = var.region
}

resource "aws_iam_role" "codepipeline_role" {
  name = var.iam_role_pipeline_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "Service": [
          "codepipeline.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role" "tf_codebuild_role" {
  name               = var.iam_role_codebuild_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codepipeline.amazonaws.com"
          ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

### IAM POLICIES ###

resource "aws_iam_policy" "tf_cicd_pipeline_policy" {
  name        = var.iam_pipeline_name
  path        = "/"
  description = "Pipeline policy"
  policy      = data.aws_iam_policy_document.tf_cicd_pipeline_policies.json
}

resource "aws_iam_policy" "tf_cicd_build_policy" {
  name        = var.iam_build_name
  path        = "/"
  description = "Codebuild policy"
  policy      = data.aws_iam_policy_document.tf_cicd_build_policies.json
}

### IAM POLICY ATTACHMENTS ###

resource "aws_iam_role_policy_attachment" "tf_cicd_pipeline_attachment" {
  policy_arn = aws_iam_policy.tf_cicd_pipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.id
}

resource "aws_iam_role_policy_attachment" "tf_cicd_codebuild_attachment1" {
  policy_arn = aws_iam_policy.tf_cicd_build_policy.arn
  role       = aws_iam_role.tf_codebuild_role.id
}

resource "aws_iam_role_policy_attachment" "tf_cicd_codebuild_attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role       = aws_iam_role.tf_codebuild_role.id
}

### DATA RESOURCES ###

data "aws_iam_policy_document" "tf_cicd_pipeline_policies" {
  statement {
    sid       = ""
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    sid       = ""
    actions   = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "tf_cicd_build_policies" {
  statement {
    sid       = ""
    actions   = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*", "iam:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}
