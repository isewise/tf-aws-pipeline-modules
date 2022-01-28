module "iam" {
  source                  = "./modules/iam"
  iam_role_pipeline_name  = "codepipeline_role"
  iam_role_codebuild_name = "codebuild_role"
  iam_pipeline_name       = "pipeline_policy"
  iam_build_name          = "codebuild_policy"
}

module "pipeline" {
  source                  = "./modules/pipeline"
  service_role_codebuild  = module.iam.tf_codebuild_role
  role_arn                = module.iam.tf_codebuild_role
  codebuild1_name         = "tf_plan"
  codebuild2_name         = "tf_apply"
  compute_type            = "BUILD_GENERAL1_SMALL"
  type                    = "LINUX_CONTAINER"
  artifact_type           = "CODEPIPELINE"
  source_type             = "CODEPIPELINE"
  image_pull_cred_type    = "SERVICE_ROLE"
  artifact_store_location = module.s3_buckets.pipeline_artifact
}

module "s3_buckets" {
  source = "./modules/s3_buckets"
}

module "remote_state" {
  source = "./modules/remote_state"

}

terraform {
  backend "s3" {
    bucket = "terraform-cicd-project-16052"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}