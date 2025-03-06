sketchybar -m --add item mic right \
           --set mic update_freq=3 \
                        script="$PLUGIN_DIR/mic.sh" \
                        click_script="$PLUGIN_DIR/mic_click.sh" \
           --subscribe mic volume_change
