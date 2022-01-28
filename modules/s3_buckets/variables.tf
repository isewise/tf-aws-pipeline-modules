variable "s3_region" {
  type = string
  default = "us-west-2"
  description = "AWS Region for S3 bucket(s) location"
}

resource "random_integer" "s3_bucket_appendix"{
    min = 1
    max = 99999  
}

resource "random_integer" "s3_pipeline_appendix"{
    min = 1
    max = 99999  
}

