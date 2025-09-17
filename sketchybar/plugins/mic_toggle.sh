#!/bin/bash

# Get current microphone volume
MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)')

# Toggle between 0 and 100 (like your original script)
if [[ $MIC_VOLUME -lt 100 ]]; then
  # Set to 100% (unmute)
  osascript -e 'set volume input volume 100'
elif [[ $MIC_VOLUME -gt 0 ]]; then
  # Set to 0% (mute)
  osascript -e 'set volume input volume 0'
fi

# Update the mic display immediately
$CONFIG_DIR/plugins/mic.sh