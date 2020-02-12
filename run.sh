#!/bin/bash

function genkey () {
  ssh-keygen
  for (( i=0; i<${tLen}; i++ ));
  do
    ssh-copy-id ${AUSER}@${ALLIPS[$i]}
  done
}

function add_known_hosts () {
  cp $1 /tmp
  chmod 700 /tmp/"$PKEY"
  for (( i=0; i<${tLen}; i++ ));
  do
    ssh -i /tmp/"$PKEY" ${AUSER}@${ALLIPS[$i]} uptime
  done
}

# Declare env variables
declare -a ALLIPS=$ALLIPS && \
tLen=${#ALLIPS[@]}
PKEYPATH=/key
PKEY=${KEYFILE}

if [ -f "$PKEYPATH/$PKEY" ]; then
  echo "$PKEYPATH/$PKEY will be used for SSH connection"
else
  echo "No private key found!  Password will be used for SSH connection"
fi

# Information
clear
echo "The host running docker MUST on the same network of ${ALLIPS[@]}"
echo "K8s hosts are ${ALLIPS[@]}"
echo "prerequisites are"
echo "1) ${ALLIPS[@]} must have access to the Internet"
echo "2) ${ALLIPS[@]} allow IPv4 forwarding"
echo "3) Your ssh key must be copied to ${ALLIPS[@]} which will be done in this program"
echo "3.1) Or if you are using private key for ssh connection, key folder MUST be mapped to /key, e.g. -v /key-folder:/key"
echo "4) In order to avoid any issue during deployment you should disable your firewall on ${ALLIPS[@]}"
echo "5) For non-root account, privilege escalation method should be configured"
read -p "Press enter to continue"
clear

# If $PKEYPATH/$PKEY is NOT found then generate ssh key for this container and copy public key across target hosts
# If $PKEYPATH/$PKEY is found then establish a ssh connection using existing key which will add remote host to ~/.ssh/known_hosts in the container
if [ -f "$PKEYPATH/$PKEY" ]; then
  add_known_hosts "$PKEYPATH/$PKEY"
else
  genkey
fi

# Generate Ansible hosts file for this project
echo "[servers]" > /etc/ansible/hosts && \
for (( i=0; i<${tLen}; i++ ));
do
  echo "node${i} ansible_host=${ALLIPS[$i]} ansible_user=${AUSER}" >> /etc/ansible/hosts
done

# Ansible Playbook start
IPS=("${ALLIPS[@]}")
CONFIG_FILE=$PWD/kubespray/inventory/mycluster/hosts.yaml python3 $PWD/kubespray/contrib/inventory_builder/inventory.py ${IPS[@]}

if [ -f "$PKEYPATH/$PKEY" ]; then
  /usr/bin/ansible-playbook --flush-cache -i $PWD/kubespray/inventory/mycluster/hosts.yaml  --become --become-user=root --private-key="/tmp/$PKEY" -e ansible_user=${AUSER} $PWD/kubespray/cluster.yml
else
  /usr/bin/ansible-playbook --flush-cache -i $PWD/kubespray/inventory/mycluster/hosts.yaml  --become --become-user=root --ask-become-pass -e ansible_user=${AUSER} $PWD/kubespray/cluster.yml
fi
