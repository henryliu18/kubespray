# Ansible/Kubespray in Docker image

### Build image
```bash
docker build . \
-t <IMAGE-NAME>
```

#### Replacing value of ALLIPS for your cluster nodes' IP in the format below.
#### Replacing value of AUSER for your cluster nodes' account( sudo required for non-root account)
#### Replacing C:\key-folder with your folder that contains openssh private key file.  The mapping location in container MUST be /key.
#### Replacing value of KEYFILE for your private key file name that is located in your key folder

### Run container (Using private key)
```bash
docker run \
--rm \
-it \
-v "C:\key-folder:/key" \
-e KEYFILE="pkey.ppk" \
-e ALLIPS="(192.168.56.133 192.168.56.162)" \
-e AUSER="ubuntu" \
<IMAGE-NAME>
```

### Run container (Using password)
```bash
docker run \
--rm \
-it \
-e ALLIPS="(192.168.56.133 192.168.56.162)" \
-e AUSER="root" \
<IMAGE-NAME>
```

#### Docker hub repository  
https://hub.docker.com/r/henryhhl18/kubespray
