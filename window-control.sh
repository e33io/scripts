#!/bin/bash

# =================================================================
# Active Window Control - move and/or resize windows
# URL: https://github.com/e33io/scripts/blob/main/window-control.sh
# -----------------------------------------------------------------
# NOTE: requires xdotool, xwininfo and wmctrl
# -----------------------------------------------------------------
# Call script with:
#   `window-control.sh move-right`  `window-control.sh width-more`
#   `window-control.sh move-left`   `window-control.sh width-less`
#   `window-control.sh move-down`   `window-control.sh height-more`
#   `window-control.sh move-up`     `window-control.sh height-less`
# =================================================================

set -eu

# x and y coordinates for active window
win_id="$(xdotool getwindowfocus)"
x_abs=$(xwininfo -id $win_id | awk '/Abs.+X/ { sub(/^.+\s/,""); print }')
y_abs=$(xwininfo -id $win_id | awk '/Abs.+Y/ { sub(/^.+\s/,""); print }')
x_rel=$(xwininfo -id $win_id | awk '/Rel.+X/ { sub(/^.+\s/,""); print }')
y_rel=$(xwininfo -id $win_id | awk '/Rel.+Y/ { sub(/^.+\s/,""); print }')
x=$(($x_abs - $x_rel))
y=$(($y_abs - $y_rel))

# width and height for active window
width=$(xdotool getactivewindow getwindowgeometry --shell | head -4 | tail -1 | sed 's/[^0-9]*//')
height=$(xdotool getactivewindow getwindowgeometry --shell | head -5 | tail -1 | sed 's/[^0-9]*//')

# move window distance (pixels)
move_win=100

# resize window distance (pixels)
resize_win=50

case $1 in
    move-right)
        # shift the x coordinates right
        x=$(($x_abs + $move_win))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    move-left)
        # shift the x coordinates left
        x=$(($x_abs - $move_win))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    move-down)
        # shift the y coordinates down
        y=$(($y_abs + $move_win))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    move-up)
        # shift the y coordinates up
        y=$(($y_abs - $move_win))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    width-more)
        # increase window width (from right side)
        width=$(($width + $resize_win))
        # resize window to the new width
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    width-less)
        # decrease window width (from right side)
        width=$(($width - $resize_win))
        # resize window to the new width
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    height-more)
        # increase window height (from bottom side)
        height=$(($height + $resize_win))
        # resize window to the new height
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
    height-less)
        # decrease window height (from bottom side)
        height=$(($height - $resize_win))
        # resize window to the new height
        wmctrl -r :ACTIVE: -e "1,$x,$y,$width,$height"
    ;;
esac
