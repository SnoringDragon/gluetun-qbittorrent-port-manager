#!/bin/bash

COOKIES="/tmp/cookies.txt"

update_port () {
  PORT=$(cat $PORT_FORWARDED)
  rm -f $COOKIES
  curl -s -c $COOKIES --data "username=$QBITTORRENT_USER&password=$QBITTORRENT_PASS" ${HTTP_S}://${QBITTORRENT_SERVER}:${QBITTORRENT_PORT}/api/v2/auth/login > /dev/null
  curl -s -b $COOKIES --data 'json={"listen_port": "'"$PORT"'"}' ${HTTP_S}://${QBITTORRENT_SERVER}:${QBITTORRENT_PORT}/api/v2/app/setPreferences > /dev/null
  rm -f $COOKIES
  echo "Successfully updated qbittorrent to port $PORT"
}

while true; do
  if [ -f $PORT_FORWARDED ]; then
    update_port
    inotifywait -mq -e close_write $PORT_FORWARDED | while read change; do
      update_port
    done
  else
    echo "Couldn't find file $PORT_FORWARDED"
    echo "Trying again in 10 seconds"
    sleep 10
  fi
done
