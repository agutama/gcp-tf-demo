#!/bin/bash
set -e

cd storage/env/dev/tf-state/
terraform init
terraform plan -var-file="../../../../all.tfvars" -compact-warnings
terraform apply -var-file="../../../../all.tfvars" -auto-approve -compact-warnings
cd -

sleep 1
cd svc-account/env/dev/pritunl
terraform init
terraform plan
terraform apply -auto-approve
cd -

sleep 1
cd svc-account/env/dev/prometheus
terraform init
terraform plan
terraform apply -auto-approve
cd -

sleep 1
cd network/env/dev/vpc/
terraform init
terraform plan -var-file="../../../../all.tfvars" -compact-warnings
terraform apply -var-file="../../../../all.tfvars" -auto-approve -compact-warnings
cd -

sleep 1
cd network/env/dev/cloud-nat/
terraform init
terraform plan -var-file="../../../../all.tfvars" -compact-warnings
terraform apply -var-file="../../../../all.tfvars" -auto-approve -compact-warnings
cd -

sleep 1
cd firewall/env/dev/
terraform init
terraform plan
terraform apply -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/pritunl/
terraform init
terraform plan
terraform apply -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/jenkins/
terraform init
terraform plan
terraform apply -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/prometheus/
terraform init
terraform plan
terraform apply -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/backend/
terraform init
terraform plan
terraform apply -auto-approve
cd -