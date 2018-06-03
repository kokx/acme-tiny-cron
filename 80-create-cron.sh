# TODO: later make this monthly, for now it is not for testing

echo '* * * * * /exec.sh' > /tmp/cron

crontab /tmp/cron
