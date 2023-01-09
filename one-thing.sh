#!/usr/bin/env bash

ONE_THING_URL="https://docs.google.com/spreadsheets/d/e/2PACX-1vS-3RlBB62GY1LcYzRIpaejoLP2eQCN4-Ly53lJb7lClWgkW2yPrRHYFbpUMOtQLCB-ZxRtEcZnlnat/pub?gid=0&single=true&output=csv"

if [ -x "$(command -v gnome-session)" ]; then
  ONE_THING_GNOME_REAL_UID=$(id --real --user)
  ONE_THING_GNOME_DIR="$HOME/.local/share/gnome-shell/extensions/one-thing@github.com"
  ONE_THING_GNOME_SCHEMA="org.gnome.shell.extensions.one-thing"
  ONE_THING_GNOME_KEY="thing-value"
  ONE_THING_GNOME_PID="$(pgrep --euid "${ONE_THING_GNOME_REAL_UID}" gnome-session | head -1 | xargs)"
  export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS "/proc/${ONE_THING_GNOME_PID}/environ" | tr -d '\0' | cut -d= -f2-)
fi

echo "$ONE_THING_GNOME_PID" > /home/francesco/Develop/_/one-thing/one-thing.log

one_thing_set() {
  gsettings --schemadir "${ONE_THING_GNOME_DIR}/schemas" set "${ONE_THING_GNOME_SCHEMA}" "${ONE_THING_GNOME_KEY}" "$1"
  echo "EXIT: $?" >> /home/francesco/Develop/_/one-thing/one-thing.log
}

one_thing_get() {
  local msg=$(gsettings --schemadir "${ONE_THING_GNOME_DIR}/schemas" get "${ONE_THING_GNOME_SCHEMA}" "${ONE_THING_GNOME_KEY}")
  [[ "${msg}" == \"*\" || "${msg}" == \'*\' ]] && msg="${msg:1:-1}"
  echo "${msg}"
}

new_msg="$(curl -sL "${ONE_THING_URL}")"
old_msg="$(one_thing_get)"

if [ "${new_msg}" != "${old_msg}" ]; then
  one_thing_set "3️⃣"; sleep 1
  one_thing_set "2️⃣"; sleep 1
  one_thing_set "1️⃣"; sleep 1
  one_thing_set "${new_msg}"
fi

one_thing_set "ZIO12"
