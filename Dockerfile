FROM woahbase/alpine-ansible
COPY run.sh /home/alpine
WORKDIR /home/alpine
CMD ["/bin/bash","/home/alpine/run.sh"]
