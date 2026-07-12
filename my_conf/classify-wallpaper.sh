#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Art"
LAND_FILE="$HOME/.config/hypr/my_conf/landscape.txt"
PORT_FILE="$HOME/.config/hypr/my_conf/portrait.txt"

> "$LAND_FILE"
> "$PORT_FILE"

while IFS= read -r image; do
    dims=$(identify -format '%w %h' "$image" 2>/dev/null) || continue
    width=$(echo "$dims" | cut -d' ' -f1)
    height=$(echo "$dims" | cut -d' ' -f2)

    if [ "$width" -gt "$height" ]; then
        echo "$image" >> "$LAND_FILE"
    else
        echo "$image" >> "$PORT_FILE"
    fi
done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \))

echo "Done: $(wc -l < "$LAND_FILE") landscape, $(wc -l < "$PORT_FILE") portrait"
