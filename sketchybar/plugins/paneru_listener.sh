#!/bin/bash
# Long-running listener: pipes paneru events into sketchybar triggers.
# Launched once from sketchybarrc, runs for the lifetime of the bar.

PANERU="${PANERU:-/opt/homebrew/bin/paneru}"

# Restart loop in case paneru is restarted / its socket goes away.
while true; do
    "$PANERU" subscribe --json 2>/dev/null | while IFS= read -r line; do
        # Forward every event as a single trigger; the strip plugin re-queries
        # paneru for current state on each fire, so we don't need to forward fields.
        sketchybar --trigger paneru_event 2>/dev/null
    done
    sleep 1
done
