#!/bin/bash

set -xeo pipefail

# Create data directory
if ! [ -d "data" ]; then
  mkdir data
fi

if [ -n "$RUN_AS" ]; then
  # Create group
  /usr/sbin/addgroup --gid $(echo -n "$RUN_AS" | cut -d: -f2) \
    monero

  # Create user
  /usr/sbin/adduser --system --home "$PWD" --shell /bin/bash \
    --uid $(echo -n "$RUN_AS" | cut -d: -f1) \
    --gid $(echo -n "$RUN_AS" | cut -d: -f2) \
    --no-create-home \
    monero

  # chown data directory
  chown -R "$RUN_AS" data
fi

# Exec monerod
if [ -n "$RUN_AS" ]; then
  exec su monero -c ./monerod -- --data-dir "$PWD/data" --log-file "$PWD/data/bitmonero.log" $MONEROD_OPTS "$@"
else
  exec ./monerod --data-dir "$PWD/data" --log-file "$PWD/data/bitmonero.log" $MONEROD_OPTS "$@"
fi
