#!/bin/bash
import -window root /tmp/scrn.png
convert -scale 10% -scale 1000% /tmp/scrn.png /tmp/.i3lock.png
i3lock -u -i /tmp/.i3lock.png
