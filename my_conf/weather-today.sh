#/usr/bin/env bash
kitty \
  --override font_size=10 \
  --override initial_window_weight=88c \
  --override initial_window_height=22c \
  -e bash -c 'curl wttr.in/Bristol\?1; stty -echo -icanon; cat > /dev/null'
