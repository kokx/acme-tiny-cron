acme-tiny-cron
==============

This is a docker container that runs a cron service to obtain new certificates from Let's Encrypt on a monthly basis.

It is based on acme-tiny and the python:alpine image.

Configuration
-------------

This container requires the following files and directories to be mounted:

- `/account.key` account key for Let's Encrypt (can be read-only).
- `/domain.key` account key for Let's Encrypt (can be read-only).
- `/challenge` directory will place challenge files (should be served as `/.well-known/acme-challenge/` on all domains).
- `/certs` directory where this container will place resulting certificate.

The account key and domain key can be generated as follows:

```sh
openssl genrsa 4096 > account.key
openssl genrsa 4096 > domain.key
```

The following environment variables can be supplied:

- `PUID` the UID of the host user from which files will be created.
- `PGID` the GID of the host group from which files will be created.
- `CERTFILE` name of the certificate file to be created.
- `DOMAINS` space-separated list of domain names to be included in the certificate (TODO: point users to limits of Let's Encrypt on this)
- `TIMEZONE` a timezone that should be set in the system before crond is started. Should exist in `/usr/share/zoneinfo`. By default, UTC is already configured.

TODO
====

- [x] Implement script that actually runs the above
- [x] Define crontab, verify if it actually runs
- [x] On startup, check if current certificate executes and is still valid for 30 days, otherwise execute /exec.sh
- [ ] Add hooks that will be executed before and after a certificate is obtained.
- [x] Figure out proper timezone setup
