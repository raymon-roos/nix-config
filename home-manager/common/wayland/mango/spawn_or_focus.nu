# Launch a program, or focus it if its already open
def main [--appID: string --cmd: string] {
  mmsg get all-clients
    | from json
    | get clients
    | where appid == $appID
    | first
    | match ($in | get id? | describe) {
      # Scary hack: `'kitty --cmd ls'`: command not found. In stead, turn into an array and destructure
      nothing => ($cmd | split row ' ' | exec ...$in)
      int => (mmsg dispatch focusid $"client,($in.id)" | ignore)
    }
}
