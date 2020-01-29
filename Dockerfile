FROM golang

WORKDIR /home/user

RUN mkdir -p /home/user/vault/{etc,data,plugins}

COPY scripts/*.sh ./
COPY etc/* /home/user/vault/etc/
COPY vault_1.3.2 /usr/bin
RUN ./install.sh
