#!/bin/bash
set -e

export TF_VAR_project="cukzlearn03"
export TF_VAR_location="asia-southeast2"
export TF_VAR_vpc_name="vpc"

if [[ $1 == "" ]]; then
    echo "Please run command: ./demo.sh [deploy or destroy]"
    exit;
elif [[ $1 == "deploy" ]]; then

    cd storage/env/dev/tf-state/
    terraform init
    terraform plan
    terraform apply  -auto-approve
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
    terraform plan
    terraform apply -auto-approve
    cd -

    sleep 1
    cd network/env/dev/cloud-nat/
    terraform init
    terraform plan 
    terraform apply -auto-approve
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
    cd compute-engine/env/dev/prometheus/
    terraform init
    terraform plan
    terraform apply -auto-approve
    cd -

elif [[ $1 == "destroy" ]]; then

    cd compute-engine/env/dev/prometheus/
    terraform destroy -auto-approve
    cd -

    cd compute-engine/env/dev/pritunl/
    terraform destroy -auto-approve
    cd -

    sleep 1
    cd firewall/env/dev/
    terraform destroy -auto-approve
    cd -

    sleep 1
    cd network/env/dev/cloud-nat/
    terraform destroy -auto-approve
    cd -

    sleep 1
    cd network/env/dev/vpc/
    terraform destroy -auto-approve
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
    terraform destroy -auto-approve
    cd -

else
  echo "Please run command: ./demo.sh [deploy or destroy]"
  exit;
fi