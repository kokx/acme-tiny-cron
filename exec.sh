#!/bin/sh

san=""

for domain in $DOMAINS ; do
    san="${san}DNS:$domain,"
done

printf "%s\n\n%s\n%s\n" "$(cat /etc/ssl/openssl.cnf)" "[SAN]" "subjectAltName=${san%?}" > /tmp/sslconf.cnf

echo "-----------------"

openssl req -new \
    -sha256 \
    -key /domain.key \
    -subj "/" \
    -reqexts SAN \
    -config /tmp/sslconf.cnf \
        > "/tmp/$CERTFILE.csr" || exit 1

acme_tiny \
    --account-key /account.key \
    --csr "/tmp/$CERTFILE.csr" \
    --acme-dir /challenge \
        > "/certs/$CERTFILE" || exit 2
