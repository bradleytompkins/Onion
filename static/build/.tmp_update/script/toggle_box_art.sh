#!/bin/sh
# Toggle box art visibility for MainUI game lists in OnionOS
ACTION="$1"

case "$ACTION" in
    hide)
        touch /mnt/SDCARD/.tmp_update/config/.hideBoxArt
        for d in /mnt/SDCARD/Roms/*/Imgs; do
            if [ -d "$d" ]; then
                parent=$(dirname "$d")
                mv "$d" "$parent/.Imgs" 2>/dev/null
            fi
        done
        ;;
    show)
        rm -f /mnt/SDCARD/.tmp_update/config/.hideBoxArt
        for d in /mnt/SDCARD/Roms/*/.Imgs; do
            if [ -d "$d" ]; then
                parent=$(dirname "$d")
                mv "$d" "$parent/Imgs" 2>/dev/null
            fi
        done
        ;;
    sync)
        if [ -f /mnt/SDCARD/.tmp_update/config/.hideBoxArt ]; then
            for d in /mnt/SDCARD/Roms/*/Imgs; do
                if [ -d "$d" ]; then
                    parent=$(dirname "$d")
                    mv "$d" "$parent/.Imgs" 2>/dev/null
                fi
            done
        else
            for d in /mnt/SDCARD/Roms/*/.Imgs; do
                if [ -d "$d" ]; then
                    parent=$(dirname "$d")
                    mv "$d" "$parent/Imgs" 2>/dev/null
                fi
            done
        fi
        ;;
esac
