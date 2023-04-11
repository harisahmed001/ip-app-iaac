remote_state {
  backend = "s3"
  config  = {
    bucket         = "wld-test-bucket-work"
    key            = "ipapp/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    region         = "us-east-1"
  }
}