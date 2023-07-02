#!/bin/bash

echo "reset_vm started..."
echo "destroying vm..."
terraform destroy -auto-approve > destroy-vm.log
echo "sleeping 10 seconds..."
sleep 10
echo "creating vm..."
terraform apply -auto-approve > create-vm.log
echo "sleeping 60 seconds for cloud-init to finish..."
sleep 60
echo "reset_vm completed."
