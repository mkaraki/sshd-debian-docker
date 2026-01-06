#!/bin/sh

create_hostkey_if_not_exists() {
    path="$1"
    type="$2"

    if [ ! -f "$path" ]; then
        ssh-keygen -q -f "$path" -N '' -t "$type" 
    fi
}

if [ ! -d "$HOSTKEY_DIR" ]; then
    mkdir -p "$HOSTKEY_DIR"
fi

RSA_HOSTKEY="$HOSTKEY_DIR/ssh_host_rsa_key"
ECDSA_HOSTKEY="$HOSTKEY_DIR/ssh_host_ecdsa_key"
ED25519_HOSTKEY="$HOSTKEY_DIR/ssh_host_ed25519_key"

create_hostkey_if_not_exists "$RSA_HOSTKEY" "rsa"
create_hostkey_if_not_exists "$ECDSA_HOSTKEY" "ecdsa"
create_hostkey_if_not_exists "$ED25519_HOSTKEY" "ed25519"

/usr/sbin/sshd -D -e -h "$RSA_HOSTKEY" -h "$ECDSA_HOSTKEY" -h "$ED25519_HOSTKEY"
