#!/usr/bin/env bash
# Note: hyprpaper is very unstable and crashes when a monitor changes.
# Workaround: use in this wrapper to spawn a new instance when a crash occurs

pkill hyprpaper

while true ; do
    hyprpaper
    sleep 1
done
