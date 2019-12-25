# Ansible/Kubespray in Docker image

### Build image
```bash
docker build . \
-t <IMAGE-NAME>
```

### Run container
#### Replacing value of ALLIPS for your cluster nodes' IP in the format below.
#### Replacing value of AUSER for your cluster nodes' credential (sudo required for non-root account)
#### Replacing C:\key-folder with your folder that contains openssh private key file (pkey.ppk), the mapping location in container MUST be /key.  If password authentication is used then simply remove -v option
```bash
docker run \
--rm \
-it \
-e ALLIPS="(192.168.56.133 192.168.56.162)" \
-e AUSER=root \
-v "C:\key-folder:/key" \
<IMAGE-NAME>
```
