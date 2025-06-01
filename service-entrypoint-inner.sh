#!/bin/bash

log_file="/mkv-auto/logs/mkv-auto.log"

touch "$log_file"
chmod 666 "$log_file"

while true; do
    if [ -f /mkv-auto/config/user.ini ]; then
        cp /mkv-auto/config/user.ini /mkv-auto/user.ini
    fi
    if [ -f /mkv-auto/config/subliminal.toml ]; then
        cp /mkv-auto/config/subliminal.toml /mkv-auto/subliminal.toml
    fi

    if ! pgrep -f 'python3 -u mkv-auto.py' > /dev/null; then
        if [ "$(ls /mkv-auto/files/input | wc -l)" -gt 0 ]; then
            cd /mkv-auto
            . /pre/venv/bin/activate
            python3 -u mkv-auto.py --service --move --silent --temp_folder /mkv-auto/files/tmp --log_file "$log_file" --input_folder /mkv-auto/files/input --output_folder /mkv-auto/files/output $DEBUG_FLAG
        fi
    fi

    sleep 5
done
