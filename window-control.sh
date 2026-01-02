#!/usr/bin/env bash

# =============================================================================
# Window Control - move, resize, or center active window
# URL: https://github.com/e33io/scripts/blob/main/window-control.sh
# -----------------------------------------------------------------------------
# NOTE: requires xdotool, xwininfo, xdpyinfo and wmctrl
# -----------------------------------------------------------------------------
# Usage: window-control.sh <command>
# Commands:
#   move-right     Move window right by 100 px
#   move-left      Move window left by 100 px
#   move-up        Move window up by 100 px
#   move-down      Move window down by 100 px
#   width-more     Increase window width by 50 px
#   width-less     Decrease window width by 50 px
#   height-more    Increase window height by 50 px
#   height-less    Decrease window height by 50 px
#   center         Center window on screen
# =============================================================================

set -eu

# Absolute & relative coordinates for active window
win_id="$(xdotool getwindowfocus)"
x_abs=$(xwininfo -id "$win_id" | awk '/Abs.+X/ { sub(/^.+\s/,""); print }')
y_abs=$(xwininfo -id "$win_id" | awk '/Abs.+Y/ { sub(/^.+\s/,""); print }')
x_rel=$(xwininfo -id "$win_id" | awk '/Rel.+X/ { sub(/^.+\s/,""); print }')
y_rel=$(xwininfo -id "$win_id" | awk '/Rel.+Y/ { sub(/^.+\s/,""); print }')
x=$((x_abs - x_rel))
y=$((y_abs - y_rel))

# Width & height for active window
width=$(xdotool getactivewindow getwindowgeometry --shell | head -4 | tail -1 | sed 's/[^0-9]*//')
height=$(xdotool getactivewindow getwindowgeometry --shell | head -5 | tail -1 | sed 's/[^0-9]*//')

# Move & resize step sizes (pixels)
move_win=100
resize_win=50

print_usage() {
    echo "Usage: $0 <command>"
    echo
    echo "Commands:"
    echo "  move-right    Move window right by $move_win px"
    echo "  move-left     Move window left by $move_win px"
    echo "  move-up       Move window up by $move_win px"
    echo "  move-down     Move window down by $move_win px"
    echo "  width-more    Increase window width by $resize_win px"
    echo "  width-less    Decrease window width by $resize_win px"
    echo "  height-more   Increase window height by $resize_win px"
    echo "  height-less   Decrease window height by $resize_win px"
    echo "  center        Center window on screen"
    echo "  -h, --help    Show this help message"
    echo
}

# Require at least one argument
if [ $# -eq 0 ]; then
    print_usage
    exit 1
fi

case "$1" in
    move-right)
        x=$((x + move_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    move-left)
        x=$((x - move_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    move-down)
        y=$((y + move_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    move-up)
        y=$((y - move_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    width-more)
        width=$((width + resize_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    width-less)
        width=$((width - resize_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    height-more)
        height=$((height + resize_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    height-less)
        height=$((height - resize_win))
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    center)
        IFS='x' read screenWidth screenHeight < <(xdpyinfo | grep dimensions | grep -o '[0-9x]*' | head -n1)
        newPosX=$((screenWidth / 2 - width / 2))
        newPosY=$((screenHeight / 2 - height / 2))
        xdotool getactivewindow windowmove "$newPosX" "$newPosY"
    ;;
    -h|--help)
        print_usage
        exit 0
    ;;
    *)
        echo "Unknown option: $1"
        echo
        print_usage
        exit 1
    ;;
esac
