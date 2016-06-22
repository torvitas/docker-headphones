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
echo "  Config:     ${CONFIG:=/datadir/config.ini}"
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
# Finally, start Headphones.
#

CONFIG=${CONFIG:-/datadir/config.ini}
echo "Starting Headphones..."
exec su -pc "./headphones/Headphones.py --data_dir=$(dirname ${CONFIG}) --config_file=${CONFIG}" ${USER}
