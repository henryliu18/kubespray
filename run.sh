#!/bin/bash

echo "Target hosts are $ALLIPS"
echo "prerequisites are"
echo "1) $ALLIPS must have access to the Internet"
echo "2) $ALLIPS allow IPv4 forwarding"
echo "3) Your ssh key must be copied to $ALLIPS"
echo "4) In order to avoid any issue during deployment you should disable your firewall on $ALLIPS"
echo "5) For non-root account, privilege escalation method should be configured"
read -p "Press enter to continue"
clear

# Declare env variables
declare -a ALLIPS=$ALLIPS && \
tLen=${#ALLIPS[@]}

# Clone kubespray repository
apk add git && \
git clone https://github.com/kubernetes-sigs/kubespray.git && pip3 install -r $PWD/kubespray/requirements.txt && cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster

# Generate ssh key for this container and copy public key across target hosts
ssh-keygen
for (( i=0; i<${tLen}; i++ ));
do
  ssh-copy-id ${AUSER}@${ALLIPS[$i]}
done

# Generate Ansible hosts file for this project
echo "[servers]" > /etc/ansible/hosts && \
for (( i=0; i<${tLen}; i++ ));
do
  echo "node${i} ansible_host=${ALLIPS[$i]} ansible_user=${AUSER}" >> /etc/ansible/hosts
done

# Ansible Playbook start
IPS=("${ALLIPS[@]}")
CONFIG_FILE=$PWD/kubespray/inventory/mycluster/hosts.yaml python3 $PWD/kubespray/contrib/inventory_builder/inventory.py ${IPS[@]}
/usr/bin/ansible-playbook --flush-cache -i $PWD/kubespray/inventory/mycluster/hosts.yaml  --become --become-user=root --ask-become-pass -e ansible_user=${AUSER} $PWD/kubespray/cluster.yml
