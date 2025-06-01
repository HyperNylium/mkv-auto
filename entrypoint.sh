#!/bin/bash

log_file='/mkv-auto/files/mkv-auto.log'

USER_ID=${UID:-1000}
GROUP_ID=${GID:-1000}
USERNAME=mkv-auto

if grep -qEi 'microsoft|wsl' /proc/version 2>/dev/null; then
    IS_LINUX=true
else
    IS_LINUX=$(uname | grep -qi linux && echo true || echo false)
fi

if [ "$IS_LINUX" = true ]; then
    if ! getent group "$GROUP_ID" >/dev/null; then
        groupadd -g "$GROUP_ID" "$USERNAME"
    fi
    if ! id -u "$USER_ID" >/dev/null 2>&1; then
        useradd -m -u "$USER_ID" -g "$GROUP_ID" "$USERNAME"
    fi
    chown -R "$USER_ID:$GROUP_ID" /mkv-auto

    # Run as non-root user
    exec gosu "$USER_ID:$GROUP_ID" bash -c ". /pre/venv/bin/activate && python3 -u mkv-auto.py --log_file $log_file $*"
else
    # Windows Docker or fallback
    . /pre/venv/bin/activate
    exec python3 -u mkv-auto.py --log_file "$log_file" "$@"
fi
