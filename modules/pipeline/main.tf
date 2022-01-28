provider "aws" {
  region = var.region
}

resource "aws_codebuild_project" "tf_plan" {
  name         = var.codebuild1_name
  description  = "TF plan stage"
  service_role = var.service_role_codebuild

  artifacts {
    type = var.artifact_type
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = var.image_pull_cred_type

    registry_credential {
      credential          = var.dockerhub_creds
      credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
    type      = var.source_type
    buildspec = file("./modules/pipeline/buildspec/apply-buildspec.yml")
  }
}

resource "aws_codebuild_project" "tf_apply" {
  name         = var.codebuild2_name
  description  = "TF apply stage"
  service_role = var.service_role_codebuild

  artifacts {
    type = var.artifact_type
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = var.image_pull_cred_type
    registry_credential {
      credential          = var.dockerhub_creds
      credential_provider = "SECRETS_MANAGER"
    }
  }
  source {
    type      = var.source_type
    buildspec = file("./modules/pipeline/buildspec/apply-buildspec.yml")
  }
}

resource "aws_codepipeline" "tf_pipeline" {
  name     = "tf_pipeline"
  role_arn = var.role_arn

  artifact_store {
    type     = var.artifact_store_type
    location = var.artifact_store_location
  }
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      output_artifacts = ["tf_code"]
      version          = "1"
      configuration = {
        FullRepositoryId     = "isewise/tf-aws-pipeline-modules"
        BranchName           = "master"
        ConnectionArn        = var.codestar_creds
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }
  stage {
    name = "Plan"
    action {
      name            = "Build"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf_code"]
      configuration = {
        ProjectName = "tf_plan"
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["tf_code"]
      configuration = {
        ProjectName = "tf_apply"
      }
    }
  }
}