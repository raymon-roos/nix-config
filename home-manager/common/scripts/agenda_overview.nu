#!/usr/bin/env nu

def fmt [] {
  each {|e| {
      eventstart: (match ($e.eventstart?) {
          null => ($e.date | format date '%a %d %b' | fill -w 16 -c ' ') 
          _ => ($e.eventstart | into datetime | format date '%a %d %b %R') 
        })
      "duration": (if ($e.duration? | is-not-empty) {
          $e.duration | into duration --unit min | format duration hr | $"\(($in)\)" 
      })
      body: $e.body
      ctx: ($"<i>[($e.filename | path parse | get stem)]</i>" | fill -c ' ' -w 17)
    }
  }
  | format pattern $'{ctx} {eventstart} <b>{body}</b>(if $in.duration != null {" {duration}" })'
  | to text
}

0..10
  | each -f {|i|
    remind --json ~/files/calendar (
      (date now) + ($i | into duration -u 'day') | format date '%F'
    )
    | from json
    | skip 1
  }
  | uniq-by filename lineno
  | chunk-by { $in.date > (date now | format date '%F') }
  | do {|today, future| 
    [ ($today | fmt | $"( 'TODAY' | fill -c '-' -a 'center' -w 83)\n($in)")
    ($future | fmt | $"( 'LATER' | fill -c '-' -a 'center' -w 83)\n($in)")
    ] | str join ""
  } $in.0? $in.1?
  | ( notify-send
      --transient
      --app-name agenda_overview
      --replace-id (makoctl list -j | from json | get 0?.id | default "0")
      -- (date now | format date ' 󰃰  %a %d %b, %Y  %R') $"($in)"
    )
