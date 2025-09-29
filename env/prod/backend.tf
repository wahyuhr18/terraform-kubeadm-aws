terraform {
  backend "s3" {
    bucket         = "homelab-terraform-state"
    key            = "eks/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    profile        = "homelab"
  }
}
