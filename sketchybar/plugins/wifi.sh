#!/bin/bash

#CURRENT_WIFI="$(networksetup -getairportnetwork en0)"
#SSID="$(networksetup -getairportnetwork en0 | awk -F ': ' '{print $2}')"
SSID="$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1;print $0 | "tr -d ':'";exit}')"
#CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"


if [ "$SSID" = "" ]; then
  sketchybar --set $NAME label="Disconnected" icon="󱛅"
else
  sketchybar --set $NAME label="$SSID" icon=""
fi
