FROM woahbase/alpine-ansible
COPY run.sh /home/alpine
WORKDIR /home/alpine
RUN apk add git && \
git clone https://github.com/kubernetes-sigs/kubespray.git && \
pip3 uninstall ansible -y && \
pip3 install -r $PWD/kubespray/requirements.txt && \
cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster
CMD ["/bin/bash","/home/alpine/run.sh"]
