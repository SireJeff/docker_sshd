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
RUN sed -i 's/MaxSessions 10/MaxSessions 1/' /etc/ssh/sshd_config
RUN echo "*               hard    maxlogins            1" >> /etc/security/limits.conf
RUN echo "*               -       maxlogins            1" >> /etc/security/limits.conf
RUN sed -i 's/MaxStartups 10:30:100/MaxStartups 1/' /etc/ssh/sshd_config
RUN echo "remote_user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN sudo mkdir /run/sshd
RUN echo "Host *" >> /etc/ssh/ssh_config \
    && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \
    && echo "UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config
CMD ["/usr/sbin/sshd","-D"]
