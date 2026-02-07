#! /bin/bash

# for laptop and one external monitor

monitor_info=$(xrandr --listactivemonitors | sed '1d')
# output example
# Monitors: 2
#  0: +*HDMI-A-0 1920/708x1080/398+1920+0  HDMI-A-0
#  1: +eDP 1920/310x1080/173+0+0  eDP
monitor_amount=$(echo "$monitor_info" | wc -l)

# can not handle more than two monitors
if [[ monitor_amount -gt 2 ]]; then
    exit 1
fi

# laptop's monitor usually is an eDP
native_monitor=$(echo "$monitor_info" | grep "eDP" | awk '{print $NF}')
# delete the line of eDP
monitor_info=$(echo "$monitor_info" | sed '/eDP/d')

external_monitor=$(echo "$monitor_info" | awk '{print $NF}')

# set primary monitor
primary_monitor=$native_monitor
if [ -n "$external_monitor" ]; then
    primary_monitor=$external_monitor
fi

xrandr --output "$primary_monitor" --primary --mode 1920x1080 --rotate normal
bspc monitor "$primary_monitor" -d 1 2 3 4 5 6

if [[ monitor_amount -eq 2 ]]; then
    xrandr --output "$native_monitor" --mode 1920x1080 --rotate left --left-of "$primary_monitor"
    bspc monitor "$native_monitor" -d 7
    bspc config -m "$native_monitor" top_padding 0 # no top bar on eDP monitor
fi
