#!/bin/bash
# Background apps display for SketchyBar

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
PANERU="${PANERU:-/opt/homebrew/bin/paneru}"

# Get running GUI applications
running_apps=$(osascript -e 'tell application "System Events" to get name of every application process whose background only is false' 2>/dev/null)

# Apps already shown in the active paneru strip (space_strip). Skip these so
# we don't draw duplicate icons in the background apps section.
strip_apps=$("$PANERU" query state --json 2>/dev/null | /usr/bin/python3 -c '
import json, sys
try:
    s = json.load(sys.stdin)
except Exception:
    sys.exit(0)
active = s.get("active", {})
nws = active.get("native_workspace_id")
vws = active.get("virtual_workspace_number")
for w in s.get("virtual_workspaces", []):
    if w.get("native_workspace_id") == nws and w.get("number") == vws:
        for win in w.get("windows", []):
            name = win.get("app_name", "")
            if name:
                print(name)
        break
')

# Apps to exclude (system apps and utilities only)
EXCLUDE_APPS=(
    "Finder"
    "SketchyBar"
    "Dock"
    "SystemUIServer"
    "Control Center"
    "NotificationCenter"
    "WindowManager"
    "Spotlight"
    "loginwindow"
    "AeroSpace"
    "paneru"
    "osascript"
    "Script Editor"
    "Automator"
    "Terminal"
    "iTerm2"
    "Activity Monitor"
    "System Settings"
    "System Preferences"
    "wezterm-gui"
    "WezTerm"
)

# Convert running apps to array
IFS=', ' read -ra apps_array <<<"$running_apps"

# Remove all existing background app items
existing_items=$(sketchybar --query bar 2>/dev/null | grep -o 'background_app\.[0-9]*')
[ -n "$existing_items" ] && echo "$existing_items" | xargs -I {} sketchybar --remove {} 2>/dev/null

# Create new items for each background app
position=0
for app in "${apps_array[@]}"; do
    # Skip if in exclude list
    skip=false
    for exclude in "${EXCLUDE_APPS[@]}"; do
        if [ "$app" = "$exclude" ]; then
            skip=true
            break
        fi
    done

    [ "$skip" = true ] && continue

    # Skip if the app is already shown in the active paneru strip.
    # Compare case-insensitively since System Events and paneru can report
    # the same app with different casing (e.g. "zed" vs "Zed").
    if [ -n "$strip_apps" ]; then
        app_lc=$(printf '%s' "$app" | tr '[:upper:]' '[:lower:]')
        while IFS= read -r strip_app; do
            strip_lc=$(printf '%s' "$strip_app" | tr '[:upper:]' '[:lower:]')
            [ "$app_lc" = "$strip_lc" ] && skip=true && break
        done <<<"$strip_apps"
    fi

    [ "$skip" = true ] && continue

    # Get icon for the app
    icon=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app" 2>/dev/null)

    # Skip invalid icons
    [ -z "$icon" ] || [ "$icon" = ":default:" ] || [ "$icon" = " " ] && continue

    item_name="background_app.$position"

    sketchybar --add item "$item_name" right \
        --set "$item_name" \
        icon="$icon" \
        icon.font="sketchybar-app-font:Regular:16.0" \
        label.drawing=off \
        icon.padding_left=4 \
        icon.padding_right=4 \
        background.color=0x662d3748 \
        background.corner_radius=5 \
        background.height=20 \
        click_script="open -a '$app'"

    position=$((position + 1))
done
