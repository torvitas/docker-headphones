#!/bin/bash
set -e

#
# Display settings on standard out.
#

USER="headphones"

echo "Headphones settings"
echo "===================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${CP_UID:=666}"
echo "  GID:        ${CP_GID:=666}"
echo
echo "  Config:     ${CONFIG:=/datadir/headphones.ini}"
echo

#
# Change UID / GID of Headphones user.
#

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${CP_UID} ]] || usermod  -o -u ${CP_UID} ${USER}
[[ $(id -g ${USER}) == ${CP_GID} ]] || groupmod -o -g ${CP_GID} ${USER}
echo "[DONE]"

#
# Set directory permissions.
#

printf "Set permissions... "
touch ${CONFIG}
chown -R ${USER}: /headphones
chown ${USER}: /datadir /media $(dirname ${CONFIG})
echo "[DONE]"

#
# Make sure config file exists
#
CONFIG=${CONFIG:-/datadir/headphones.ini}
if [ ! -f ${CONFIG} ]; then
    cp /headphones/headphones.ini /datadir/
fi

#
# Finally, start Headphones.
#

echo "Starting Headphones..."
exec su -pc "./Headphones.py --datadir=$(dirname ${CONFIG}) --config=${CONFIG}" ${USER}
