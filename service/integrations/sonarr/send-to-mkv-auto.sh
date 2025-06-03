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

# Get the directory that contained the episode file (or folder)
parent_dir="$(dirname "$source_path")"

# Check if directory still contains any mkv, mp4, jpg, png, or srt files
# or any subdirectories. Only delete if neither files nor subdirs remain.
if [ -d "$parent_dir" ]; then
    shopt -s nullglob nocaseglob

    # Collect any media/subtitle/image files
    files=("$parent_dir"/*.{mkv,mp4,jpg,png,srt})

    # Collect any subdirectories
    dirs=("$parent_dir"/*/)

    shopt -u nullglob nocaseglob

    # If no media/subtitle/image files AND no subdirectories remain, delete the directory
    if [ ${#files[@]} -eq 0 ] && [ ${#dirs[@]} -eq 0 ]; then
        rm -rf "$parent_dir"

        # Check if parent_dir was named "Season N" and delete its parent if it's now empty
        season_dir_name="$(basename "$parent_dir")"
        if [[ "$season_dir_name" =~ ^[Ss]eason\ [0-9]+$ ]]; then
            grandparent_dir="$(dirname "$parent_dir")"
            if [ -d "$grandparent_dir" ]; then
                # Check if grandparent still contains any files/directories
                shopt -s nullglob
                remaining=("$grandparent_dir"/*)
                shopt -u nullglob
                if [ ${#remaining[@]} -eq 0 ]; then
                    rm -rf "$grandparent_dir"
                fi
            fi
        fi
    fi
fi
