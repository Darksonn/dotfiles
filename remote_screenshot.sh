#!/bin/bash
basename="$(date +%s).png"
dir='/tmp'
import "$dir/$basename"
scp "$dir/$basename" 'archan:/home/user/public_html/s'
ip='http://ryhl.moe/~user/s'
url="$ip/$basename"
echo "$url" | xclip -i -selection p
echo "$url" | xclip -i -selection sec
echo "$url" | xclip -i -selection clip
echo "$url"

