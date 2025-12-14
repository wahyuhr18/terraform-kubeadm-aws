#!/bin/bash
set -euo pipefail

terraform init

terraform apply \
  -var="env=dev" \
  -var="region=us-east-1" \
  -var="profile=homelab" \
  -var="bucket_name=homelab-terraform-state-dev-v1" \
  -var="dynamodb_table_name=terraform-lock-dev" \
  -auto-approve
