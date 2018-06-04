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
- `/hooks/pre.sh` shell script that will be executed just before a certificate is requested from Let's Encrypt.
- `/hooks/post.sh` shell script that will be executed just after a certificate is requested from Let's Encrypt.

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

Hooks
=====
Pre- and post-execution hooks can be defined by mounting them in the container at `/hooks/pre.sh` and `/hooks/post.sh`.

For example, the following pre-hook will start a simple webserver to serve the challenge file:

```sh
echo "doing pre"
mkdir -p /tmp/serve/.well-known
ln -s /challenge /tmp/serve/.well-known/acme-challenge
(cd /tmp/serve && python -m http.server) &
sleep 1 # wait a bit for the server to start
# (note that the script must run the python server in the background)
```

And the corresponding `post.sh` file will shut it down and do cleanup:

```sh
killall python
rm -r /tmp/serve
```
