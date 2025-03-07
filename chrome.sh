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

touch "${XDG_CONFIG_HOME}/google-chrome/WidevineCdm"

# enable PKCS11 modules on extensions
modules_root=/app/pki/modules
if [ -d "$modules_root" ]; then
  find "$modules_root" -name "*.module" -exec ln -sf '{}' /etc/pkcs11/modules \;
fi

#check the NSSDB for the library p11-kit-proxy.so
if ! [ -d "$HOME/.pki/nssdb" ]; then
    mkdir -p "$HOME/.pki/nssdb"
    /app/bin/modutil -dbdir sql:"$HOME/.pki/nssdb" -create -force
fi
if ! /app/bin/modutil -dbdir sql:$HOME/.pki/nssdb -list 2>/dev/null | grep -q "p11-kit-proxy"; then
  /app/bin/modutil -dbdir sql:$HOME/.pki/nssdb -add "p11-kit-proxy" -libfile /usr/lib/x86_64-linux-gnu/p11-kit-proxy.so -force
fi

exec cobalt "$@"
