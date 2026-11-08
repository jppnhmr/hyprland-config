#!/usr/bin/env bash
# Sets a random wallpaper from one folder, never the same one twice in a row.

wallpaper_dir="$HOME/Pictures/Wallpapers"

last_file="${XDG_STATE_HOME:-$HOME/.local/state}/last-wallpaper"

mapfile -d '' images < <(find -L "$wallpaper_dir" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0)

if ((${#images[@]} == 0)); then
    hyprctl notify 3 10000 0 "No wallpapers found in $wallpaper_dir"
    exit 1
fi

last=$(cat "$last_file" 2>/dev/null)
while true; do
    pick=${images[RANDOM % ${#images[@]}]}
    [[ $pick != "$last" || ${#images[@]} -eq 1 ]] && break
done

# awww-daemon is started at the same moment as this script, so wait for it.
for _ in {1..50}; do
    awww query >/dev/null 2>&1 && break
    sleep 0.1
done

awww img --resize crop --fill-color 000000 --transition-type fade --transition-duration 1 "$pick" || exit 1

mkdir -p "$(dirname "$last_file")"
printf '%s\n' "$pick" >"$last_file"
