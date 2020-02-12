FROM woahbase/alpine-ansible
RUN apk add git && \
git clone https://github.com/kubernetes-sigs/kubespray.git && \
pip3 install -r $PWD/kubespray/requirements.txt && \
cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster

COPY run.sh /home/alpine
WORKDIR /home/alpine
CMD ["/bin/bash","/home/alpine/run.sh"]
