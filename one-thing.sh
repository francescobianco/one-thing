#!/usr/bin/env bash

TODOIST_TASK=6622166072
TODOIST_TOKEN=2c60c9f8ca3ee07a8cdff35d37a2d0dc94fc5b23

curl "https://api.todoist.com/rest/v2/tasks/$TODOIST_TASK" \
    -d '{"content": "Buy 🔥 3"}' \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TODOIST_TOKEN"


curl -s "https://api.todoist.com/rest/v2/tasks/$TODOIST_TASK" \
    -H "Authorization: Bearer $TODOIST_TOKEN" | jq -r ".content"

exit

ONE_THING_URL="https://docs.google.com/spreadsheets/d/e/2PACX-1vS-3RlBB62GY1LcYzRIpaejoLP2eQCN4-Ly53lJb7lClWgkW2yPrRHYFbpUMOtQLCB-ZxRtEcZnlnat/pub?gid=0&single=true&output=csv"

if [ -x "$(command -v gnome-session)" ]; then
  ONE_THING_GNOME_REAL_UID=$(id --real --user)
  ONE_THING_GNOME_DIR="$HOME/.local/share/gnome-shell/extensions/one-thing@github.com"
  ONE_THING_GNOME_SCHEMA="org.gnome.shell.extensions.one-thing"
  ONE_THING_GNOME_KEY="thing-value"
  ONE_THING_GNOME_PID="$(pgrep --euid "${ONE_THING_GNOME_REAL_UID}" gnome-session | head -1 | xargs)"
  export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS "/proc/${ONE_THING_GNOME_PID}/environ" | tr -d '\0' | cut -d= -f2-)
fi

one_thing_set() {
  gsettings --schemadir "${ONE_THING_GNOME_DIR}/schemas" set "${ONE_THING_GNOME_SCHEMA}" "${ONE_THING_GNOME_KEY}" "$1"
}

one_thing_get() {
  local msg=$(gsettings --schemadir "${ONE_THING_GNOME_DIR}/schemas" get "${ONE_THING_GNOME_SCHEMA}" "${ONE_THING_GNOME_KEY}")
  [[ "${msg}" == \"*\" || "${msg}" == \'*\' ]] && msg="${msg:1:-1}"
  echo -e "${msg}"
}

new_msg="$(curl -sL "${ONE_THING_URL}")"
old_msg="$(one_thing_get)"

if [ "${new_msg}" = "Sincronizzazione di Calendar" ]; then
  exit
fi

if [ "${new_msg}" != "${old_msg}" ]; then
  one_thing_set "3️⃣"; sleep 1
  one_thing_set "2️⃣"; sleep 1
  one_thing_set "1️⃣"; sleep 1
  one_thing_set "${new_msg}"
fi
