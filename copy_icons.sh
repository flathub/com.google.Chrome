#!/bin/bash

# Helper script to copy all the Chrome icons from an installation directory

DIR=${1:-/opt/google/chrome}

mkdir -p icons

for icon in "$DIR"/product_logo_*.png; do
  size=$(echo "$icon" | grep -Eo '[0-9]+')
  cp "$icon" icons/com.google.Chrome-$size.png
done
