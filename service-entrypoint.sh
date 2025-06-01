#!/bin/bash

USER_ID=${UID:-1000}
GROUP_ID=${GID:-1000}
USERNAME=mkv-auto

if ! getent group "$GROUP_ID" >/dev/null; then
    groupadd -g "$GROUP_ID" "$USERNAME"
fi

if ! id -u "$USER_ID" >/dev/null 2>&1; then
    useradd -m -u "$USER_ID" -g "$GROUP_ID" "$USERNAME"
fi

chown -R "$USER_ID:$GROUP_ID" /mkv-auto

exec gosu "$USER_ID:$GROUP_ID" /mkv-auto/service-entrypoint-inner.sh
