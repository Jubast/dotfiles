#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Reload all polybars 
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITORPOLYBAR=$m polybar top &
done
