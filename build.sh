#!/bin/bash

# Due to data fitting errors, we notify when a build fails or not
# Useful watchers:
    #while inotifywait -qe close_write,modify data/trainers/ ; do ./build.sh; done
    #Get-Content build.log -Wait

python roster_gen.py --generate-asm || { echo "fail" >> build.log; exit 1; }

make RGBDS=rgbds-0.5.2/ || { echo "fail" >> build.log; exit 1; }
tput bel
echo "ok" >> build.log

# Display checksum to help fingerprint build
sha1sum pokeyellow.gbc

# Stats on memory bank usage
capacity=16384
used=$(grep '\["Battle Engine 6"\]' pokeyellow.map | sed -E 's/.*\(\$([0-9A-Fa-f]+) bytes\).*/0x\1/' | xargs printf "%d")
free=$((capacity -used))
delta=$((used - 15504))
printf "Used: %6d B\nFree: %6d B\nFull: %6.2f%%\nDelta: %+5d B\n" $used $free $(awk "BEGIN { printf \"%.2f\", ($used / $capacity) * 100 }") $delta
