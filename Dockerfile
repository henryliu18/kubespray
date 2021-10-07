FROM woahbase/alpine-ansible
COPY run.sh /home/alpine
WORKDIR /home/alpine
RUN apk update && \
apk add gcc && \
apk add git && \
apk add python3-dev && \
apk add musl-dev && \
apk add libffi-dev && \
apk add openssl-dev && \
/usr/bin/python3.7 -m pip install --upgrade pip && \
git clone https://github.com/kubernetes-sigs/kubespray.git && \
pip3 uninstall ansible -y && \
pip3 install -r $PWD/kubespray/requirements.txt && \
cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster
CMD ["/bin/bash","/home/alpine/run.sh"]
