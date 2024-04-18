#!/usr/bin/env bash
# Note: waybar is very unstable and crashes quiet often.
# Workaround: use in this wrapper to spawn a new waybar when a crash occurs

pkill waybar

while true ; do
    waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css
    sleep 1
done
