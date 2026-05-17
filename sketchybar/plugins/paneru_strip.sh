#!/bin/bash
# Renders the active paneru strip: a space indicator + an icon strip of windows
# on the currently-active virtual workspace of the focused display.

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
PANERU="${PANERU:-/opt/homebrew/bin/paneru}"
ICON_FN="$CONFIG_DIR/plugins/icon_map_fn.sh"

state=$("$PANERU" query state --json 2>/dev/null) || exit 0
[ -z "$state" ] && exit 0

active_native=$(printf '%s' "$state" | /usr/bin/python3 -c '
import json, sys
s = json.load(sys.stdin)
print(s.get("active", {}).get("native_workspace_id", ""))
')

active_virtual=$(printf '%s' "$state" | /usr/bin/python3 -c '
import json, sys
s = json.load(sys.stdin)
print(s.get("active", {}).get("virtual_workspace_number", ""))
')

# Collect app names for the active strip (matching active native + virtual workspace).
apps=$(printf '%s' "$state" | /usr/bin/python3 -c '
import json, sys
s = json.load(sys.stdin)
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

icon_strip=""
if [ -n "$apps" ]; then
    while IFS= read -r app; do
        [ -z "$app" ] && continue
        ico=$("$ICON_FN" "$app" 2>/dev/null)
        [ -n "$ico" ] && icon_strip+=" $ico"
    done <<<"$apps"
fi
[ -z "$icon_strip" ] && icon_strip=" "

sketchybar --set space_indicator label="Space $active_native"
sketchybar --set space_strip label="$icon_strip"
