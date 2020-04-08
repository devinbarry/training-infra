remote_state {
  backend = "s3"
  config = {
    bucket         = "jengu-ops"
    key            = "terraform/training-infra/default/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state"
  }
}
