#!/bin/bash

dbus-monitor "interface='org.freedesktop.Notifications'" |
awk '
  /member=Notify/ { in_notify=1; app=""; next }
  in_notify && /string "/ {
    match($0, /string "(.*)"/, m)
    if (app == "") {
      app = m[1]
      if (app != "Hyprshot" && app != "grimblast" && app != "Grimblast") {
        system("canberra-gtk-play -i message >/dev/null 2>&1 &")
      }
      in_notify=0
    }
  }
'
