#!/bin/bash

python roster_gen.py

# Due to data fitting errors, we notify when a build fails or not
# Useful watchers:
    #while inotifywait -qe close_write,modify data/trainers/ ; do ./build.sh; done
    #Get-Content build.log -Wait

if make RGBDS=rgbds-0.5.2/; then
    tput bel
    echo "success" >> build.log
else
    echo "fail" >> build.log
fi
