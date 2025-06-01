#!/bin/bash

# Exit successfully if it's just a test run
if [ -z "$sonarr_episodefile_path" ] && [ -z "$sonarr_series_path" ]; then
    exit 0
fi

# If the event is SeriesAdd and sonarr_episodefile_path is not set,
# use sonarr_series_path instead (if available)
if [ "$sonarr_eventtype" = "SeriesAdd" ] && [ -z "$sonarr_episodefile_path" ] && [ -n "$sonarr_series_path" ]; then
    source_path="$sonarr_series_path"
elif [ -n "$sonarr_episodefile_path" ]; then
    source_path="$sonarr_episodefile_path"
else
    exit 0
fi

# If the source path exists as a file or directory, move it
if [ -e "$source_path" ]; then
    mv "$source_path" "/mkv-auto-input"
fi

# Get the directory that contained the episode file
parent_dir="$(dirname "$source_path")"

# Check if directory still contains any mkv, mp4, jpg, png, or srt files
if [ -d "$parent_dir" ]; then
    shopt -s nullglob nocaseglob
    files=("$parent_dir"/*.{mkv,mp4,jpg,png,srt})
    shopt -u nullglob nocaseglob

    # If no such files remain, delete the directory
    if [ ${#files[@]} -eq 0 ]; then
        rm -rf "$parent_dir"
    fi
fi