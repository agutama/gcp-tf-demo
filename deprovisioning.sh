#!/bin/bash

sleep 1
cd compute-engine/env/dev/pritunl/
terraform destroy -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/jenkins/
terraform destroy -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/prometheus/
terraform destroy -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/backend/
terraform destroy -auto-approve
cd -

sleep 1
cd compute-engine/env/dev/nfs-server/
terraform destroy -auto-approve
cd -

sleep 1
cd firewall/env/dev/
terraform destroy -auto-approve
cd -

sleep 1
cd network/env/dev/cloud-nat/
terraform destroy -var-file="../../../vpc.tfvars" -auto-approve
cd -

sleep 1
cd network/env/dev/vpc/
terraform destroy -var-file="../../../vpc.tfvars" -auto-approve
cd -

sleep 1
cd svc-account/env/dev/pritunl
terraform destroy -auto-approve
cd -

sleep 1
cd svc-account/env/dev/prometheus
terraform destroy -auto-approve
cd -

cd storage/env/dev/tf-state/
terraform destroy -var-file="../../../gcs.tfvars" -auto-approve
cd -