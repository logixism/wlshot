#!/usr/bin/fish

function screenshot
    grim -t jpeg -q 100 $image
end

function capture
    screenshot

    hyprpicker -r -z & sleep 0.1
    set hyprpickerPid $last_pid

    if [ $MODE = "region" ]
        set -g geometry (slurp -d)
    else if [ $MODE = "screen" ]
        set -g geometry (slurp -o)
    end

    kill -9 $hyprpickerPid

    if [ "$geometry" = "" ]
        rm -f $image
        exit
    end
    
    set pos +(echo $geometry | cut -d' ' -f1 | string replace ',' '+') # ex. +0+0
    set size (echo $geometry | cut -d' ' -f2)
    magick $image -crop $size$pos $image

    wl-copy --type image/png < "$image"
    notify-send "Screenshot saved" "Image saved and copied to the clipboard." -t "2000" -i "$image" -a wlshot
end

set OUTPUT_FOLDER ~/pictures/screenshots
set MODE region

for arg in $argv
    switch $arg
        case -m
            set MODE $argv[2]
        case -o
            set OUTPUT_FOLDER $argv[2]
    end
end

set image $OUTPUT_FOLDER/(date +"%F %T %N.jpeg")

capture