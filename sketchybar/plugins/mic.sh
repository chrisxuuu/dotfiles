#!/bin/bash

# Get microphone input volume
MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)')

if [[ $MIC_VOLUME -eq 0 ]]; then
  ICON="󰍭"  # Muted microphone icon
  LABEL="0"
  COLOR="0xffff6b6b"  # Red color for muted
else
  case "$MIC_VOLUME" in
    100) ICON="󰍬"  # High volume mic
    ;;
    [5-9][0-9]) ICON="󰍬"      # Medium volume mic
    ;;
    [1-4][0-9]) ICON="󰍭"      # Low volume mic
    ;;
    *) ICON="󰍭"               # Very low/no volume mic
  esac
  LABEL="$MIC_VOLUME"
  COLOR="0xffffffff"  # White color for active
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL" icon.color="$COLOR" label.color="$COLOR"