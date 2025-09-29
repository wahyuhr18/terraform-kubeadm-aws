terraform {
  backend "s3" {
    bucket         = "homelab-terraform-state"
    key            = "eks/staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    profile        = "homelab"
  }
}
