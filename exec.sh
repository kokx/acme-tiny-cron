#!/bin/sh

source /hooks/pre.sh

function error() {
    # always execute post hook
    source /hooks/post.sh
    exit $1
}

san=""

for domain in $DOMAINS ; do
    san="${san}DNS:$domain,"
done

printf "%s\n\n%s\n%s\n" "$(cat /etc/ssl/openssl.cnf)" "[SAN]" "subjectAltName=${san%?}" > /tmp/sslconf.cnf

openssl req -new \
    -sha256 \
    -key /domain.key \
    -subj "/" \
    -reqexts SAN \
    -config /tmp/sslconf.cnf \
        > "/tmp/$CERTFILE.csr" || error 1

acme_tiny \
    --account-key /account.key \
    --csr "/tmp/$CERTFILE.csr" \
    --acme-dir /challenge \
        > "/certs/$CERTFILE" || error 2

source /hooks/post.sh
