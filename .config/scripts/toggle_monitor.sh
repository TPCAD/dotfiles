#! /bin/bash

target_monitor="$1"
source_monitor="$2"

# major to secondary
# secondary monitor | major monitor
# 7 | 1 2 3 4 5 6
# 7 1 2 3 4 5 | 6 prev
# major monitor | secondary monitor
# 1 2 3 4 5 6 | 7
# 6 | 7 1 2 3 4 5 prev
#
# secondary to major
# secondary monitor | major monitor
# 7 | 1 2 3 4 5 6
# 7 | 1 2 3 4 5 6  prev
# major monitor | secondary monitor
# 1 2 3 4 5 6 | 7
# 1 2 3 4 5 6 | 7 prev

for desktop in $(bspc query -D -m "$source_monitor" --names); do
    # echo "info: send $desktop to $target_monitor"
    bspc desktop "$desktop" -m "$target_monitor"
    if [[ $? -eq 1 ]]; then
        # echo "info: last desktop $desktop"
        for node in $(bspc query -N -d "$desktop"); do
            # echo "info: send $node to prev desktop"
            bspc node "$node" -d prev
        done
    fi
done

bspc monitor "$target_monitor" -d 1 2 3 4 5 6
bspc monitor "$source_monitor" -d 7
