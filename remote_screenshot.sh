#!/bin/bash
pubkey='/home/user/.ssh/archan_id_rsa'
basename="$(date +%s).png"
dir='/tmp'
import "$dir/$basename"
scp -i "$pubkey" -P 50002 "$dir/$basename" 'user@ryhl.moe:/home/user/public_html/s'
ip='http://ryhl.moe/~user/s'
url="$ip/$basename"
echo "$url" | xclip -i -selection p
echo "$url" | xclip -i -selection sec
echo "$url" | xclip -i -selection clip
echo "$url"

