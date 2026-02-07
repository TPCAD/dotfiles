#! /bin/bash

selected=$(ls ~/.config/rofi/scripts/ | rofi -dmenu -p "Run: ")
/bin/bash ~/.config/rofi/scripts/$selected
