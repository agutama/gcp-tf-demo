#!/bin/bash

cd gcp-terraform/storage/tf-state/
terraform init
terraform plan -var-file="../gcs.tfvars"
terraform apply -var-file="../gcs.tfvars" -auto-approve
cd ../../../

sleep 1
cd gcp-terraform/svc-account/env/dev/pritunl
terraform init
terraform plan
terraform apply -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/svc-account/env/dev/prometheus
terraform init
terraform plan
terraform apply -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/network/env/dev/vpc/
terraform init
terraform plan -var-file="../../../vpc.tfvars"
terraform apply -var-file="../../../vpc.tfvars" -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/network/env/dev/cloud-nat/
terraform init
terraform plan -var-file="../../../vpc.tfvars"
terraform apply -var-file="../../../vpc.tfvars" -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/firewall/env/dev/
terraform init
terraform plan
terraform apply -auto-approve
cd ../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/pritunl/
terraform init
terraform plan
terraform apply -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/jenkins/
terraform init
terraform plan
terraform apply -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/prometheus/
terraform init
terraform plan
terraform apply -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/backend/
terraform init
terraform plan
terraform apply -auto-approve
cd ../../../../../