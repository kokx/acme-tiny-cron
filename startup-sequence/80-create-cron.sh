# TODO: later make this monthly, for now it is not for testing

# 1:15 A.M. on the 5th of every month

echo '15 1 5 * * /exec.sh' > /tmp/cron

crontab /tmp/cron
