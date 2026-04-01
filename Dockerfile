FROM debian:trixie-slim@sha256:26f98ccd92fd0a44d6928ce8ff8f4921b4d2f535bfa07555ee5d18f61429cf0c

# renovate: suite=trixie depName=openssh-server
ARG OPENSSH_SERVER_VERSION="1:10.0p1-7"

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
