#!/bin/bash
set -e

echo "==============================="
echo "  Homelab Terraform + Ansible Runner "
echo "==============================="

# --- Pilih Profile ---
echo "Authentication mode:"
echo "1) Pilih AWS Profile"
echo "2) Buat AWS Profile baru"
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
  read -p "Enter new profile name: " PROFILE
  aws configure --profile "$PROFILE"
  echo "✅ Profile '$PROFILE' created. Please rerun the script."
  exit 0
else
  echo "❌ Invalid choice!"
  exit 1
fi

# --- Pilih Environment ---
echo
echo "Select Environment:"
echo "1) prod"
echo "2) staging"
echo "3) dev"
read -p "Choice [1/2/3]: " ENV_CHOICE

case $ENV_CHOICE in
  1) ENV="prod"; VAR_FILE="env/prod/prod.tfvars" ;;
  2) ENV="staging"; VAR_FILE="env/staging/staging.tfvars" ;;
  3) ENV="dev"; VAR_FILE="env/dev/dev.tfvars" ;;
  *) echo "❌ Invalid choice!"; exit 1 ;;
esac

# --- Pilih Action ---
echo
echo "Select Action:"
echo "1) apply"
echo "2) destroy"
echo "3) plan"
read -p "Choice [1/2/3]: " ACTION_CHOICE

case $ACTION_CHOICE in
  1) ACTION="apply" ;;
  2) ACTION="destroy" ;;
  3) ACTION="plan" ;;
  *) echo "❌ Invalid choice!"; exit 1 ;;
esac

# --- Set Backend Config ---
case $ENV in
  prod) BACKEND_FILE="env/prod/backend.tf" ;;
  staging) BACKEND_FILE="env/staging/backend.tf" ;;
  dev) BACKEND_FILE="env/dev/dev-backend.tf" ;;
esac

# --- Eksekusi Terraform ---
echo
echo "🚀 Running Terraform [$ACTION] for environment: $ENV"
echo "👉 Using Profile: $AWS_PROFILE | Region: $AWS_DEFAULT_REGION"

terraform init -upgrade -backend-config="$BACKEND_FILE"
terraform $ACTION -var-file="$VAR_FILE" -var="profile=$AWS_PROFILE" -auto-approve
echo "✅ Terraform $ACTION completed for environment: $ENV"
echo

# --- Update kubeconfig ---
CLUSTER_NAME=$(terraform output -raw eks_cluster_id)
REGION=$(terraform output -raw region 2>/dev/null || echo "$AWS_DEFAULT_REGION")

echo "[INFO] Updating kubeconfig for cluster: $CLUSTER_NAME in region: $REGION"
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION" --profile "$AWS_PROFILE"

echo "[INFO] Testing cluster connection..."
kubectl get nodes
