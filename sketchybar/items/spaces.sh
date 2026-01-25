#!/bin/bash

# Dynamically get all workspace IDs from aerospace
SPACE_SIDS=($(aerospace list-workspaces --all))

# Remove all existing space items to avoid duplicates
sketchybar --remove '/space\..*/' 2>/dev/null

# Add space items for each workspace
for sid in "${SPACE_SIDS[@]}"; do
    sketchybar --add space space.$sid left \
        --set space.$sid \
        space=$sid \
        icon=$sid \
        label.font="sketchybar-app-font:Regular:16.0" \
        label.padding_right=20 \
        label.y_offset=-1 \
        script="$PLUGIN_DIR/space.sh"
done

# Add the separator (only if it doesn't exist)
if ! sketchybar --query space_separator &>/dev/null; then
    sketchybar --add item space_separator left \
        --set space_separator \
        icon="󰇙" \
        icon.color=$ACCENT_COLOR \
        icon.padding_left=4 \
        label.drawing=off \
        background.drawing=off \
        script="$PLUGIN_DIR/space_windows.sh" \
        --subscribe space_separator space_windows_change
fi

# Add a hidden item that monitors workspace changes and triggers this script
if ! sketchybar --query spaces_monitor &>/dev/null; then
    sketchybar --add item spaces_monitor left \
        --set spaces_monitor \
        drawing=off \
        script="$PLUGIN_DIR/spaces.sh" \
        --subscribe spaces_monitor aerospace_workspace_change
fi
