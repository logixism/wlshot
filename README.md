# wlshot 
 A screenshot tool for wayland that allows for freezing the screen to take a screenshot. At the core, just a wrapper for grim & imagemagick

## installation ✨
 install the dependencies listed below, and then copy wlshot to `/usr/bin`

| dependency  | description     |
|-------------|-----------------|
| `hyprpicker`| freezing screen |
| `grim`      | taking screenshot|
| `imagemagick`| cropping screenshot|
| `wl-copy`   | copying screenshot to clipboard|


## usage 🚀
 By default, wlshot will take a screenshot in jpeg format</br>

 `wlshot` takes the following flags:
| flag          | description     | default                | allowed values       |
|---------------|-----------------|------------------------|----------------------|
| -o, --output  | output file     |`~/pictures/screenshots`| any directory        |
| -m, --mode    | screenshot mode | `region`               | `screen`, `region`   |
| -f, --format  | output format   | `jpeg`                 | `jpeg`, `ppm`, `png` |
| -c, --convert | convert to      |                        | `png`, `jpg`, `jpeg` |
</br>

> [!WARNING]
> Using `-f png` is not recommended as it may take a while to capture the screenshot. Instead, use `-f ppm` and `-c png` together in order to capture a `ppm` screenshot, later converting it to png (much faster!)

## contributing 🔨
 feel free to submit PRs/issues, and i will take a look at them!<br/><br/>
 p.s: if you can find a way to take png screenshots without it taking a second (on a triple monitor setup), i will gladly accept the solution :)
