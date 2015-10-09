#!/bin/bash
basename="$(date +%s).png"
ip='http://ryhl.moe/s'
dir='/home/user/srv/files/s'
import "$dir/$basename"
url="$ip/$basename"
echo "$url" | xclip -i -selection p
echo "$url" | xclip -i -selection sec
echo "$url" | xclip -i -selection clip
echo "$url"

