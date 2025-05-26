#!/bin/bash

# If env sonarr_episodefile_path is not set, exit 0 (for test)
if [ -z "$sonarr_episodefile_path" ]; then
    exit 0
fi

# If the file exists, move it to /mkv-auto-input
if [ -f "$sonarr_episodefile_path" ]; then
    mv "$sonarr_episodefile_path" "/mkv-auto-input"
fi