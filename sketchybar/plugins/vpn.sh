#!/bin/bash
VPN=$(scutil --nc list | grep Connected | sed -E 's/.*"(.*)".*/\1/')
if [[ $VPN != "" ]]; then
  sketchybar --set "$NAME" icon="󰖂" \
                          label="$VPN" \
                          drawing=on \
                          icon.color=0xff4ade80 \
                          label.color=0xffffffff
else
  sketchybar --set "$NAME" drawing=off
fi