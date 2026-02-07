#! /bin/bash

# Convert bases via bc
# deps: rofi, bc, xclip

# echo "obase=16; ibase=10; 256" | bc

set -euo pipefail

arg="$1"
# arg="db1101"
# warg="hx256"

obase="h"
ibase="d"
num=""

check_arg() {
    [[ $1 =~ ^[hdob]{2} ]] || {
        echo "Error: Wrong base. Only support (h)exdecimal, (d)ecimal, (o)ctal and (b)inary."
        exit 1
    }
}

parse_arg() {
    obase="${arg:0:1}"
    ibase="${arg:1:1}"
    num="${arg:2}"
    case "$obase" in
        "b") obase=2 ;;
        "d") obase=10 ;;
        "h") obase=16 ;;
        "o") obase=8 ;;
        *) echo "Error: Not support output base: $obase."; exit 1 ;;
    esac

    case "$ibase" in
        "b") ibase=2 ;;
        "d") ibase=10 ;;
        "h") ibase=16 ;;
        "o") ibase=8 ;;
        *) echo "Error: Not support input base: $ibase."; exit 1 ;;
    esac
}

check_number() {
    case "$ibase" in
        2) allowed='^[0-1]+$' ;;
        8) allowed='^[0-7]+$' ;;
        10) allowed='^[0-9]+$' ;;
        16) allowed='^[0-9a-fA-F]+$' ;;
        *)  return 1 ;;
    esac
    # echo "$allowed"
    # echo "$num"
    [[ "$num" =~ $allowed ]] || {
          echo "Error: Number could not match base."
          exit 1
    }

    num=$(echo "$num" | tr '[:lower:]' '[:upper:]')
}

check_arg "$arg"
parse_arg "$arg"

# echo "$obase $ibase $num"

check_number
echo "obase=$obase; ibase=$ibase; $num" | bc
