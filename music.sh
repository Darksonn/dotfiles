#!/bin/bash
case "$1" in
  "toggle")
    echo '{"command":["cycle","pause"]}' | socat - /tmp/music
    ;;
  "next")
    echo '{"command":["playlist-next","weak"]}' | socat - /tmp/music
    ;;
  "prev")
    echo '{"command":["playlist-prev","weak"]}' | socat - /tmp/music
    ;;
esac
