#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

# Define muted blue colors
FOCUSED_BG="0x88517C9B"     # Muted blue for focused workspace
UNFOCUSED_BG="0x442d3748"   # Darker muted blue for unfocused workspace
BORDER_COLOR="0xAA517C9B"   # Muted blue border

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=$FOCUSED_BG label.shadow.drawing=off icon.shadow.drawing=off background.border_width=2 background.border_color=$BORDER_COLOR
else
  sketchybar --set $NAME background.color=$UNFOCUSED_BG label.shadow.drawing=off icon.shadow.drawing=off background.border_width=0
fi