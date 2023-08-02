#!/bin/bash

sleep 1
cd gcp-terraform/compute-engine/env/dev/pritunl/
terraform destroy -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/jenkins/
terraform destroy -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/prometheus/
terraform destroy -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/backend/
terraform destroy -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/compute-engine/env/dev/nfs-server/
terraform destroy -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/firewall/env/dev/
terraform destroy -auto-approve
cd ../../../../

sleep 1
cd gcp-terraform/network/env/dev/cloud-nat/
terraform destroy -var-file="../../../vpc.tfvars" -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/network/env/dev/vpc/
terraform destroy -var-file="../../../vpc.tfvars" -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/svc-account/env/dev/pritunl
terraform destroy -auto-approve
cd ../../../../../

sleep 1
cd gcp-terraform/svc-account/env/dev/prometheus
terraform destroy -auto-approve
cd ../../../../../

cd gcp-terraform/storage/tf-state/
terraform destroy -var-file="../gcs.tfvars" -auto-approve
cd ../../../