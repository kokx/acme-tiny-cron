if [ -n "$TIMEZONE" ]
then
    rm /etc/localtime
    ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
fi
