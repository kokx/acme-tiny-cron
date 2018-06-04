FROM python:alpine

RUN apk add --no-cache --virtual build-dependencies curl \
    && apk add --no-cache --virtual runtime-dependencies openssl \
        su-exec \
        tzdata \
        shadow \
    && curl -L https://github.com/diafygi/acme-tiny/archive/4.0.4.tar.gz | tar xz \
    && mv acme-tiny-4.0.4/acme_tiny.py /bin/acme_tiny \
    && apk del build-dependencies \
    && adduser -S acme \
    && addgroup -S acme

COPY entrypoint.sh /
COPY /startup-sequence /startup-sequence/

COPY exec.sh /

ENTRYPOINT ["/entrypoint.sh"]
