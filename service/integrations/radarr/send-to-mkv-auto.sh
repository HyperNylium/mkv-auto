#!/bin/bash

# Exit successfully if it's just a test run
if [ -z "$radarr_moviefile_path" ] && [ -z "$radarr_movie_path" ]; then
    exit 0
fi

# If the event is MovieAdded and radarr_moviefile_path is not set,
# use radarr_movie_path instead (if available)
if [ "$radarr_eventtype" = "MovieAdded" ] && [ -z "$radarr_moviefile_path" ] && [ -n "$radarr_movie_path" ]; then
    source_path="$radarr_movie_path"
elif [ -n "$radarr_moviefile_path" ]; then
    source_path="$radarr_moviefile_path"
else
    exit 0
fi

# If the source path exists (file or directory), move it
if [ -e "$source_path" ]; then
    mv "$source_path" "/mkv-auto-input"
fi

# Get the directory that contained the movie file (or folder)
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

    # Only delete if neither files nor subdirectories remain
    if [ ${#files[@]} -eq 0 ] && [ ${#dirs[@]} -eq 0 ]; then
        rm -rf "$parent_dir"
    fi
fi