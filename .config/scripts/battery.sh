#! /bin/bash

# support only one battery case

set -euo pipefail

read_file() {
    local f=$1
    [[ -r $f ]] && cat "$f" || echo "N/A"
}

print_charge() {
    if [[ $1 == "now" || $1 == "full" || $1 == "full_design" ]]; then
        cap=$(read_file "$battery_path/charge_$1")
        if [[ $cap != "N/A" ]]; then
            cap=$((cap / 1000))
            printf "%s mAh\n" "$cap"
            exit 0
        fi
    fi
    echo "$cap" # N/A
}

health() {
    full=$(read_file "$battery_path/charge_full")
    design=$(read_file "$battery_path/charge_full_design")
    health="N/A"
    if [[ $full != "N/A" && $design != "N/A" && $design -gt 0 ]]; then
        health=$((full * 100 / design))
    fi
    echo "$health%"
}

# main

BAT_DIR=/sys/class/power_supply

battery_path=
for d in "$BAT_DIR"/BAT*; do
    [[ -d $d ]] || continue
    battery_path=$d
    break
done

if [[ -z ${battery_path:-} ]]; then
    echo "No battery found"
    exit 1
fi

if [[ $# = 0 ]]; then
    printf "%-20s: %s\n" "Battery" "$(basename "$battery_path")"
    printf "%-20s: %s\n" "Status" "$(read_file "$battery_path/status")"
    printf "%-20s: %s\n" "Capacity" "$(read_file "$battery_path/capacity")"
    printf "%-20s: %s\n" "Current Volume" "$(print_charge "now")"
    printf "%-20s: %s\n" "Full Volume" "$(print_charge "full")"
    printf "%-20s: %s\n" "Full Design Volume" "$(print_charge "full_design")"
    printf "%-20s: %s\n" "Health" "$(health)"
    exit 0
fi

case "$1" in
    status) read_file "$battery_path/status" ;;
    capacity) read_file "$battery_path/capacity" ;;
    now) print_charge "now" ;;
    full) print_charge "full" ;;
    design) print_charge "full_design" ;;
    health) health ;;
esac
