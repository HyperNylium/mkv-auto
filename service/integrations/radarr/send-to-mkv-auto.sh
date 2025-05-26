#!/bin/bash

# If env radarr_moviefile_path is not set, exit 0 (for test)
if [ -z "$radarr_moviefile_path" ]; then
    exit 0
fi

# If the file exists, move it to /mkv-auto-input
if [ -f "$radarr_moviefile_path" ]; then
    mv "$radarr_moviefile_path" "/mkv-auto-input"
fi