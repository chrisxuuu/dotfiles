#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# Pretty date/time format without extra spaces
sketchybar --set "$NAME" icon.drawing=off label="$(date '+%a %d %b • %H:%M')"