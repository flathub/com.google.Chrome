#!/usr/bin/bash

# Merge the policies with the host ones.
policy_root=/etc/opt/chrome/policies

for policy_type in managed recommended enrollment; do
  policy_dir="$policy_root/$policy_type"
  mkdir -p "$policy_dir"

  if [[ -d "/run/host/$policy_root/$policy_type" ]]; then
    find "/run/host/$policy_root/$policy_type" -type f -name '*' \
      -exec ln -sf '{}' "$policy_root/$policy_type" \;
  fi
done

# Keep Chrome on the bundled Widevine CDM. A regular file at this path stops
# the component updater from installing copies there, which the Zypak sandbox
# cannot load. Replace a directory left by an earlier download with that file.
widevine_path="${XDG_CONFIG_HOME}/google-chrome/WidevineCdm"
mkdir -p "${XDG_CONFIG_HOME}/google-chrome"
if [[ -d "$widevine_path" ]]; then
  rm -rf -- "$widevine_path"
fi
touch "$widevine_path"

exec cobalt "$@"
