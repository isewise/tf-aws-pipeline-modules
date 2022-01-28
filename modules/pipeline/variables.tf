### CODEBUILD VARIABLES ###

variable "region" {
  type = string
  default = "us-west-2"
}

variable "codebuild1_name" {
  type        = string
  description = "Name for the Codebuild Project. A name is required for each stage"
}

variable "codebuild2_name" {
  type        = string
  description = "Name for the Codebuild Project. A name is required for each stage"
}

variable "service_role_codebuild" {
  type        = string
  description = "Amazon Resource Name (ARN) of the AWS Identity and Access Management (IAM) role that enables AWS CodeBuild to interact with dependent AWS services on behalf of the AWS account."
}

variable "compute_type" {
  type = string
  description = "Information about the compute resources the build project will use. Valid values: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type must be BUILD_GENERAL1_LARGE."
  validation {
    condition = anytrue([
      var.compute_type == "BUILD_GENERAL1_SMALL",
      var.compute_type == "BUILD_GENERAL1_MEDIUM",
      var.compute_type == "BUILD_GENERAL1_LARGE",
      var.compute_type == "BUILD_GENERAL1_2XLARGE",
      var.compute_type == "BUILD_GENERAL1_SMALL"
    ])
    error_message = "Valid values: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type must be BUILD_GENERAL1_LARGE."
  }
}

variable "image" {
  type = string
  default = "hashicorp/terraform:latest"
}

variable "type" {
  type = string
  description = "Type of build environment to use for related builds. Valid values: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER (deprecated), WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER."
  validation {
    condition = anytrue([
      var.type == "LINUX_CONTAINER",
      var.type == "LINUX_GPU_CONTAINER",
      var.type == "WINDOWS_CONTAINER",
      var.type == "WINDOWS_SERVER_2019_CONTAINER",
      var.type == "ARM_CONTAINER"
    ])
    error_message = "Type must be 'LINUX_CONTAINER', 'LINUX_GPU_CONTAINER', 'WINDOWS_CONTAINER' (deprecated), 'WINDOWS_SERVER_2019_CONTAINER', or 'ARM_CONTAINER'." 
  }   
}

variable "image_pull_cred_type" {
  type = string
  description = "Type of credentials AWS CodeBuild uses to pull images in your build. Valid values: CODEBUILD, SERVICE_ROLE"
  validation {
    condition = anytrue([
      var.image_pull_cred_type == "CODEBUILD",
      var.image_pull_cred_type == "SERVICE_ROLE"
    ])
    error_message = "Valid values are either 'CODEBUILD' or 'SERVICE_ROLE'."
  }
}

variable "source_type" {
  type = string
  description = "Type of repository that contains the source code to be built. Valid values: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3, NO_SOURCE."
  validation {
    condition = anytrue([
      var.source_type == "CODECOMMIT",
      var.source_type == "CODEPIPELINE",
      var.source_type == "GITHUB",
      var.source_type == "GITHUB_ENTERPRISE",
      var.source_type == "BITBUCKET",
      var.source_type == "S3",
      var.source_type == "NO_SOURCE"
    ])
    error_message = "Valid values: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3, NO_SOURCE."
  }
}

### CODEPIPELINE VARIABLES ###

variable "artifact_type" {
  type = string
  description = "Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3."
  validation {
    condition = anytrue([
      var.artifact_type == "CODEPIPELINE",
      var.artifact_type == "NO_ARTIFACTS",
      var.artifact_type == "S3"
    ])
    error_message = "Valid values: CODEPIPELINE, NO_ARTIFACTS, S3."
  }
}

variable "dockerhub_creds" {
  type        = string
  default     = "arn:aws:secretsmanager:us-west-2:062326170122:secret:dockerhub_creds-gNbZAz"
  description = "Dockerhub credentials to prevent rate limiting on downloading images"
}

variable "role_arn" {
  type = string
  description = "Role ARN for codebuild jobs" 
}

variable "artifact_store_type" {
  type = string
  default = "S3"
  description =  "The type of the artifact store, such as Amazon S3"
}

variable "artifact_store_location" {
  type = string
  default = "S3"
  description = "The location where AWS CodePipeline stores artifacts for a pipeline; currently only S3 is supported."
}

variable "codestar_creds" {
  type = string
  default = "arn:aws:codestar-connections:us-west-2:062326170122:connection/1bb0f53a-5072-4fa9-873d-5638e12156e1" 
}

variable "tf-version" {
  type        = string
  default     = "latest"
  description = "Which version of TF to download for the Codebuild jobs"
}

# variable "environment_variables" {
#   type = list(object(
#     {
#       name  = string
#       value = string
#       type  = string
#   }))

#   description = "Configuration block. A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
# }

# variable "registry_credential" {
#   type = list(object(
#     {
#       credential          = string
#       credential_provider = string
#   }))

#   default = [
#     {
#       credential          = "arn:aws:secretsmanager:us-west-2:062326170122:secret:dockerhub_creds-gNbZAz"
#       credential_provider = "SECRETS_MANAGER"
#   }]
#   description = "Credential configuration for access to private Docker registry."
# }


# variable "environment" {
#   type = list(object(
#     {
#       compute_type = string
#       image        = string
#       type         = string
#     }
#   ))
#   default = [
#     {
#       compute_type                = "BUILD_GENERAL1_SMALL"
#       image                       = "hashicorp/terraform:latest"
#       type                        = "LINUX_CONTAINER"
#       image_pull_credentials_type = "SERVICE_ROLE"
#   }]
# }