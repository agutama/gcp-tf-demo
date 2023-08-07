#!/bin/bash
set -e

export TF_VAR_project="cukzlearn03"
export TF_VAR_location="asia-southeast2"
export TF_VAR_vpc_name="vpc"

if [[ $1 == "" ]]; then
    echo "Please run command: ./basic.sh [deploy or destroy]"
    exit;
elif [[ $1 == "deploy" ]]; then
    cd storage/env/dev/tf-state/
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
    cd firewall/env/dev/
    terraform init
    terraform plan
    terraform apply -auto-approve
    cd -

    sleep 1
    cd compute-engine/env/dev/generic-ubuntu/
    terraform init
    terraform plan
    terraform apply -auto-approve
    cd -

elif [[ $1 == "destroy" ]]; then

    sleep 1
    cd compute-engine/env/dev/generic-ubuntu/
    terraform destroy -auto-approve
    cd -

    cd firewall/env/dev/
    terraform destroy -auto-approve
    cd -

    sleep 1
    cd network/env/dev/vpc/
    terraform destroy -auto-approve
    cd -

    sleep 1
    cd storage/env/dev/tf-state/
    terraform destroy -auto-approve
    cd -
else
  echo "Please run command: ./basic.sh [deploy or destroy]"
  exit;
fi