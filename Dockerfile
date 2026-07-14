FROM debian:trixie-slim@sha256:020c0d20b9880058cbe785a9db107156c3c75c2ac944a6aa7ab59f2add76a7bd

# renovate: suite=trixie depName=openssh-server
ARG OPENSSH_SERVER_VERSION="1:10.0p1-7+deb13u4"

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server="${OPENSSH_SERVER_VERSION}" \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV HOSTKEY_DIR=/keys/hostkey

RUN sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    rm /etc/ssh/ssh_host_*_key

RUN --mount=type=secret,id=root-passwd,env=ROOT_PASSWD \
    echo "root:${ROOT_PASSWD:-12345678}" | chpasswd

COPY --chmod=555 sshd-entrypoint.sh /sshd-entrypoint.sh

VOLUME /keys
EXPOSE 22

CMD [ "/sshd-entrypoint.sh" ]
