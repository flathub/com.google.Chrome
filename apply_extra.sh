#!/usr/bin/sh
set -e

bsdtar -Oxf chrome.deb 'data.tar*' |
  bsdtar -xf - \
    --strip-components=4 \
    --exclude='./opt/google/chrome/nacl*' \
    ./opt/google/chrome
rm chrome.deb

install -Dm755 /app/bin/stub_sandbox chrome-sandbox
