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
x=$(xwininfo -id $win_id | awk '/Abs.+X/ { sub(/^.+\s/,""); print }')
y=$(xwininfo -id $win_id | awk '/Abs.+Y/ { sub(/^.+\s/,""); print }')
x_rel=$(xwininfo -id $win_id | awk '/Rel.+X/ { sub(/^.+\s/,""); print }')
y_rel=$(xwininfo -id $win_id | awk '/Rel.+Y/ { sub(/^.+\s/,""); print }')

# width and height for active window
width=$(xdotool getactivewindow getwindowgeometry --shell | head -4 | tail -1 | sed 's/[^0-9]*//')
height=$(xdotool getactivewindow getwindowgeometry --shell | head -5 | tail -1 | sed 's/[^0-9]*//')

# shift window distance (pixels)
shift_win=100

# resize window distance (pixels)
resize_win=50
resize_adj=$(( $resize_win / 2 ))

case $1 in
    move-right)
        # shift the x coordinates right
        x=$(( $x + $shift_win ))
        y=$(( $y - $y_rel ))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
    move-left)
        # shift the x coordinates left
        x=$(( $x - $shift_win ))
        y=$(( $y - $y_rel ))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
    move-down)
        # shift the y coordinates down
        x=$(( $x - $x_rel ))
        y=$(( $y + $shift_win ))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
    move-up)
        # shift the y coordinates up
        x=$(( $x - $x_rel ))
        y=$(( $y - $shift_win ))
        # move window to the new coordinates
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
    width-more)
        # increase window width (left and right)
        width=$(( $width + $resize_win ))
        y=$(( $y - $y_rel ))
        x=$(( $x - $x_rel - $resize_adj ))
        # resize window to the new width
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
    width-less)
        # decrease window width (left and right)
        width=$(( $width - $resize_win ))
        y=$(( $y - $y_rel ))
        x=$(( $x - $x_rel + $resize_adj ))
        # resize window to the new width
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
    height-more)
        # increase window height (top and bottom)
        height=$(( $height + $resize_win ))
        y=$(( $y - $y_rel - $resize_adj ))
        x=$(( $x - $x_rel ))
        # resize window to the new height
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
    height-less)
        # decrease window height (top and bottom)
        height=$(( $height - $resize_win ))
        y=$(( $y - $y_rel + $resize_adj ))
        x=$(( $x - $x_rel ))
        # resize window to the new height
        wmctrl -r :ACTIVE: -e "0,$x,$y,$width,$height"
    ;;
esac
