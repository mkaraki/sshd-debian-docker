FROM debian:trixie-slim@sha256:4bcb9db66237237d03b55b969271728dd3d955eaaa254b9db8a3db94550b1885

# renovate: suite=trixie depName=openssh-server
ARG OPENSSH_SERVER_VERSION="1:10.0p1-7"

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server="${OPENSSH_SERVER_VERSION}" \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=5s --timeout=1s --retries=3 CMD unbound-control status || exit 1

CMD [ "/usr/sbin/sshd", "-D", "-e" ]
