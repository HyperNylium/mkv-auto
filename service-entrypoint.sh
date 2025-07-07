#!/bin/bash

USER_ID=${UID:-1000}
GROUP_ID=${GID:-1000}

chown -R "$USER_ID:$GROUP_ID" /mkv-auto
exec gosu "$USER_ID:$GROUP_ID" /mkv-auto/service-entrypoint-inner.sh