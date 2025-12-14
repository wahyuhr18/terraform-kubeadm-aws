#!/bin/bash
set -euo pipefail

echo "==============================="
echo " 🌩️  Homelab Terraform Runner "
echo "==============================="
echo
# Tampilkan daftar profile yang sudah ada
echo "Available AWS Profiles:"
aws configure list-profiles || echo "(no profiles found)"
echo

# Pilihan mode
echo "Select option:"
echo "1) Use existing AWS profile"
echo "2) Create a new AWS profile"
read -p "Choice [1/2]: " PROFILE_OPTION
echo

case "$PROFILE_OPTION" in
  1)
    # Gunakan profile yang sudah ada
    read -p "Enter AWS Profile name: " PROFILE
    read -p "Enter AWS Region [default: us-east-1]: " REGION
    REGION=${REGION:-us-east-1}
    ;;
  2)
    # Buat profile baru
    read -p "Enter new AWS Profile name: " PROFILE
    aws configure --profile "$PROFILE"
    read -p "Enter AWS Region [default: us-east-1]: " REGION
    REGION=${REGION:-us-east-1}
    ;;
  *)
    echo "❌ Invalid choice!"
    exit 1
    ;;
esac

# Export environment variables
export AWS_PROFILE="$PROFILE"
export AWS_DEFAULT_REGION="$REGION"

echo "✅ Using AWS Profile: $AWS_PROFILE | Region: $AWS_DEFAULT_REGION"
echo "==============================="

# === Pilih Environment ===
echo
echo "Select Environment:"
echo "1) prod"
echo "2) staging"
echo "3) dev"
read -rp "Choice [1/2/3]: " ENV_CHOICE

case "$ENV_CHOICE" in
  1) ENV="prod" ;;
  2) ENV="staging" ;;
  3) ENV="dev" ;;
  *) echo "Invalid choice"; exit 1 ;;
esac

VAR_FILE="env/${ENV}/${ENV}.tfvars"
BACKEND_FILE="env/${ENV}/backend.tfvars"

# === Pilih Action ===
echo
echo "Select Action:"
echo "1) init"
echo "2) plan"
echo "3) apply"
echo "4) destroy"
read -rp "Choice : " ACTION_CHOICE

ACTION=$(case "$ACTION_CHOICE" in
  1) echo "init" ;;
  2) echo "plan" ;;
  3) echo "apply" ;;
  4) echo "destroy" ;;
  *) echo "Invalid choice"; exit 1 ;;
esac)

# === Eksekusi Terraform ===
echo
echo "🚀 Running Terraform [$ACTION] for [$ENV]"
echo "👉 Profile: $AWS_PROFILE | Region: $AWS_DEFAULT_REGION"

terraform init -migrate-state -backend-config="$BACKEND_FILE"
#terraform init -backend-config="$BACKEND_FILE"
terraform "$ACTION" \
  -var-file="$VAR_FILE" \
  -var="profile=$AWS_PROFILE"

echo "✅ Terraform $ACTION completed for environment: $ENV"

# === Update kubeconfig ===
echo
if terraform output -raw eks_cluster_id &>/dev/null; then
  CLUSTER_NAME=$(terraform output -raw eks_cluster_id)
  echo "🔁 Updating kubeconfig for cluster: $CLUSTER_NAME"
  aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION" --profile "$AWS_PROFILE"
  kubectl get nodes || echo "⚠️ Cluster belum siap sepenuhnya."
else
  echo "ℹ️ No EKS cluster found — skipping kubeconfig update."
fi
