#!/usr/bin/fish

function screenshot
    grim -t jpeg -q 100 $image
end

function capture
    screenshot

    hyprpicker -r -z & sleep 0
    set hyprpickerPid $last_pid

    set geometry ""
    set requiresCrop 0

    if [ $MODE = "region" ]
        set geometry (slurp -d)
        set requiresCrop 1
    else if [ $MODE = "screen" ]
        set geometry (slurp -o)
        set requiresCrop 1
    end

    kill -9 $hyprpickerPid
    
    if [ $requiresCrop = 1 ]
        set pos +(echo $geometry | cut -d' ' -f1 | string replace ',' '+') # ex. +0+0
        set size (echo $geometry | cut -d' ' -f2)
        magick $image -crop $size$pos $image
    end

    wl-copy --type image/png < "$image"
end

set OUTPUT_FOLDER /home/logix/pictures/screenshots
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