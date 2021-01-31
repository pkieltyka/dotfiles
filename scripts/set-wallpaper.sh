#!/usr/bin/env bash

wallpapers="/home/peter/Pictures/wallpapers/"

img="$wallpapers`ls $wallpapers | sort -R | tail -$N | head -n 1`"

feh --bg-fill $img

