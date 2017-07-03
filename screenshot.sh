#!/bin/bash
basename="$(date +%s).png"
basenamejpg="$(date +%s).jpg"
ip='http://ryhl.moe/~user/s'
dir='/home/user/public_html/s'
import "$dir/$basename"
convert "$dir/$basename" "$dir/$basenamejpg"
url="$ip/$basenamejpg"
echo -n "$url" | xclip -i -selection p
echo -n "$url" | xclip -i -selection sec
xclip -selection clip -t image/png "$dir/$basename"

