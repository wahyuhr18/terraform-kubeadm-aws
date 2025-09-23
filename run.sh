#!/bin/bash
set -e

echo "==============================="
echo "  Homelab Terraform Multi-Env Runner  "
echo "==============================="

# --- Pilih Mode Auth ---
echo "Authentication mode:"
echo "1) AWS Profile"
echo "2) Manual Access Key + Secret Key"
read -p "Choice [1/2]: " AUTH_MODE

if [ "$AUTH_MODE" == "1" ]; then
  echo "Available AWS Profiles:"
  aws configure list-profiles
  read -p "Select AWS Profile: " PROFILE
  read -p "Enter AWS Region [default: us-east-1]: " REGION
  REGION=${REGION:-us-east-1}

  export AWS_PROFILE="$PROFILE"
  export AWS_DEFAULT_REGION="$REGION"

elif [ "$AUTH_MODE" == "2" ]; then
  read -p "Enter AWS Access Key ID: " ACCESS_KEY
  read -s -p "Enter AWS Secret Access Key: " SECRET_KEY
  echo
  read -p "Enter AWS Region [default: ap-southeast-1]: " REGION
  REGION=${REGION:-ap-southeast-1}

  export AWS_ACCESS_KEY_ID="$ACCESS_KEY"
  export AWS_SECRET_ACCESS_KEY="$SECRET_KEY"
  export AWS_DEFAULT_REGION="$REGION"

else
  echo "❌ Invalid choice!"
  exit 1
fi

# --- Menu ---
echo
echo "Select option:"
echo "1a) prod apply"
echo "1b) prod destroy"
echo "1c) prod plan"
echo "2a) dev apply"
echo "2b) dev destroy"
echo "2c) dev plan"

read -p "Choice: " CHOICE

case $CHOICE in
  1a)
    ENV="prod"; VAR_FILE="env/prod.tfvars"; ACTION="apply" ;;
  1b)
    ENV="prod"; VAR_FILE="env/prod.tfvars"; ACTION="destroy" ;;
  1c)
    ENV="prod"; VAR_FILE="env/prod.tfvars"; ACTION="plan" ;;
  2a)
    ENV="dev"; VAR_FILE="env/dev.tfvars"; ACTION="apply" ;;
  2b)
    ENV="dev"; VAR_FILE="env/dev.tfvars"; ACTION="destroy" ;;
  2c)
    ENV="dev"; VAR_FILE="env/dev.tfvars"; ACTION="plan" ;;
  *)
    echo "❌ Invalid choice! Use: 1a | 1b | 1c | 2a | 2b | 2c"
    exit 1 ;;
esac

# --- Eksekusi Terraform ---
echo
echo "🚀 Running Terraform [$ACTION] for environment: $ENV"
if [ "$AUTH_MODE" == "1" ]; then
  echo "👉 Using Profile: $AWS_PROFILE | Region: $AWS_DEFAULT_REGION"
else
  echo "👉 Using AccessKey: $AWS_ACCESS_KEY_ID | Region: $AWS_DEFAULT_REGION"
fi

terraform init -upgrade
terraform $ACTION -var-file="$VAR_FILE"
