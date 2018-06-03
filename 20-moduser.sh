# allow users to set the user for which files are saved

PUID=${PUID:-100}
PGID=${PGID:-100}

groupmod -o -g "$PGID" acme
usermod -o -u "$PUID" acme
