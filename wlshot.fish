#!/usr/bin/fish

function screenshot
    grim -t $FORMAT $IMAGE.$FORMAT
end

function capture
    screenshot

    hyprpicker -r -z & sleep 0.1 # freeze screen; not sleeping causes weird flashing
    set hyprpickerPid $last_pid

    if [ $MODE = "region" ]
        set -g geometry (slurp -d)
    else if [ $MODE = "screen" ]
        set -g geometry (slurp -o)
    end

    kill -9 $hyprpickerPid # thaw the screen

    if [ "$geometry" = "" ]
        rm -f $IMAGE.$FORMAT
        exit
    end
    
    set pos +(echo $geometry | cut -d' ' -f1 | string replace ',' '+') # ex. +0+0
    set size (echo $geometry | cut -d' ' -f2)

    magick $IMAGE.$FORMAT -crop $size$pos $IMAGE.$FORMAT # crop the image

    if [ "$CONVERT_TO" != "" ]
        magick $IMAGE.$FORMAT $IMAGE.$CONVERT_TO # if specified, convert the image to the required format
        wl-copy --type image/png < "$IMAGE.$CONVERT_TO"
        rm -f "$IMAGE.$FORMAT"
        notify-send "Screenshot saved" "Image saved and copied to the clipboard." -t "2000" -i "$IMAGE.$CONVERT_TO" -a wlshot
    else
        wl-copy --type image/png < "$IMAGE.$FORMAT"
        notify-send "Screenshot saved" "Image saved and copied to the clipboard." -t "2000" -i "$IMAGE.$FORMAT" -a wlshot
    end
end

set OUTPUT_FOLDER ~/pictures/screenshots
set MODE region
set FORMAT jpeg
set CONVERT_TO

argparse --name=wlshot 'm/mode=' 'o/output=' 'f/format=' 'c/convert=' -- $argv

if [ "$_flag_o" != "" ]
    set OUTPUT_FOLDER $_flag_o
end
if [ "$_flag_f" != "" ]
    set FORMAT $_flag_f
end
if [ "$_flag_c" != "" ]
    set CONVERT_TO $_flag_c
end
if [ "$_flag_m" != "" ]
    set MODE $_flag_m
end

set IMAGE $OUTPUT_FOLDER/(date +"%F %T %N")

capture