if [ -e "/certs/$CERTFILE" ]
then
    atleast=$(date -d '+32 days' '+%s')
    certdate=$(date -d "$(openssl x509 -in /certs/$CERTFILE -noout -dates | grep notAfter | sed 's/^notAfter=//')" '+%s')

    if [ "$atleast" -ge "$certdate" ]
    then
        su-exec acme:acme /exec.sh
    fi
else
    su-exec acme:acme /exec.sh
fi
