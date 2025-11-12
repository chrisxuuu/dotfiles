#!/bin/bash
# Test version that actually creates items

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

echo "=== Removing existing background app items ==="
existing_items=$(sketchybar --query bar 2>/dev/null | grep -o 'background_app\.[0-9]*')
if [ -n "$existing_items" ]; then
    echo "Found existing items: $existing_items"
    echo "$existing_items" | xargs -I {} sketchybar --remove {} 2>/dev/null
else
    echo "No existing items found"
fi

echo -e "\n=== Getting running apps ==="
running_apps=$(osascript -e 'tell application "System Events" to get name of every application process whose background only is false' 2>/dev/null)
echo "Running apps: $running_apps"

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

IFS=', ' read -ra apps_array <<< "$running_apps"

echo -e "\n=== Creating items ==="
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
    
    # Get icon for the app
    icon=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app" 2>/dev/null)
    
    # Skip invalid icons
    if [ -z "$icon" ] || [ "$icon" = ":default:" ] || [ "$icon" = " " ]; then
        echo "Skipping $app - invalid icon: '$icon'"
        continue
    fi
    
    item_name="background_app.$position"
    
    echo "Creating $item_name for $app with icon $icon"
    
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
    
    # Verify it was created
    if sketchybar --query "$item_name" &>/dev/null; then
        echo "✓ $item_name created successfully"
        # Show what sketchybar sees
        sketchybar --query "$item_name" | grep -E "(icon|label|drawing)" | head -5
    else
        echo "✗ Failed to create $item_name"
    fi
    
    position=$((position + 1))
done

echo -e "\n=== Checking font ==="
sketchybar --query bar | grep -i font | head -5

echo -e "\n=== Summary ==="
echo "Created $position background app items"