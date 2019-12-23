# Ansible/Kubespray in Docker image

### Build image
```bash
docker build . -t <IMAGE-NAME>
```

## Replacing value of ALLIPS for your cluster nodes' IP in the format below.
## Replacing value of AUSER for your cluster nodes' credential (sudo required for non-root account)

### Run container
```bash
docker run --rm -it -e ALLIPS="(192.168.56.133 192.168.56.162)" -e AUSER=root <IMAGE-NAME>
```
