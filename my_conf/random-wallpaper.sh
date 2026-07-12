#!/bin/bash

LAND_FILE="$HOME/.config/hypr/my_conf/landscape.txt"
PORT_FILE="$HOME/.config/hypr/my_conf/portrait.txt"

LAND_WALL=$(shuf -n 1 "$LAND_FILE")
PORT_WALL=$(shuf -n 1 "$PORT_FILE")

[ -n "$LAND_WALL" ] && awww img "$LAND_WALL" --transition-type fade --resize fit --outputs DP-1
[ -n "$PORT_WALL" ] && awww img "$PORT_WALL" --transition-type fade --resize fit --outputs DP-2
