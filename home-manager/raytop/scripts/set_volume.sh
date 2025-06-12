#!/usr/bin/env bash

## Control audio volume through bemenu
#
# bemenu output isn't limited to the supplied options. It can be used as a general input box as well.
# This invocations shows the current sound level, and allows typing a specific value (or increment)
# in wpctl format. for example: 10%, 0.1, 0.2+ 10%+
# Because binding '3%+' to a media key is not granular enough, and too slow if I want a big change.

wpctl get-volume @DEFAULT_SINK@ |
    awk -F ': ' '{print $2}' |
    bemenu |
    xargs -r -I{} wpctl set-volume -l 0.8 @DEFAULT_SINK@ '{}'
