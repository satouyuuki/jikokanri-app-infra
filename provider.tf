provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

provider "aws" {
  alias      = "acm"
  region = "us-east-1"
}