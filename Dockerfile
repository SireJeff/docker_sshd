FROM ubuntu:latest
RUN mkdir -p /var/run/sshd

RUN apt update && \
apt install -y openssh-server &&\
apt install -y openjdk-8-jdk

RUN useradd -rm -d /home/remote_user -s /bin/bash remote_user && \
echo remote_user:password1234 | chpasswd

RUN mkdir /home/remote_user/.ssh && \
chmod 700 /home/remote_user/.shh

COPY id_rsa.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user -R /home/remote_user/.ssh && \
    chmod 600 /home/remote_user/.ssh/authorized_keys

CMD ["/usr/sbin/sshd","-D"]
