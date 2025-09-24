## NixOS/Home-Manager flake

I previously managed my dotfiles through [yadm][1]. When I heard about
Nix(Os) - and while I was assigned a MacBook Air for work - I made the switch. The module
system and the language make it possible to handle discrepancies between machines in a way
that a plain git repo of dotfiles doesn't. And Nix really succeeds in managing
_everything_ on the system, not just user space.

[1]: https://yadm.io/

The xyz-as-code approach in general resonates a lot with me. I like how NixOS makes
experimentation fearless, because I can (almost) always revert to a working state. Back
when I used Arch, doing a slightly complex setup of some kind could be a little scary,
because giving up halfway through the process left a mess I had to undo manually. On top
of that, the NixOS modules feel like cheating. So many advanced features that are just
a `enable = true;` away.

This flake features configuration for my personal desktop and laptop (Thinkpad T560).
Previously it also had a Mac system managed by nix-darwin. You can look through the commit
history to find it if you're interested.

I strongly favor a keyboard-driven workflow, and terminal (CLI and TUI) applications.
[Colemak_dh][2] is my keyboard layout of choice, and on top of that I strongly rely on
multiple layers and [home-row mods][3]. On my desktop I get all these features from
a [QMK][4] custom keyboard. On my laptop I use [keyd][5] to achieve the same
customizability of the integrated keyboard through software. On MacOS I've used
[kmonad][6] and [kanata][7] for this end (check commit history for details).

[2]: https://colemakmods.github.io/mod-dh/
[3]: https://precondition.github.io/home-row-mods
[4]: https://docs.qmk.fm/
[5]: https://github.com/rvaiya/keyd
[6]: https://github.com/kmonad/kmonad
[7]: https://github.com/jtroo/kanata

## Some features

- Wayland desktop with the [Hyprland][8] compositor, until I find something else that has
  both the tiling and workspace mechanics I want. There are modules for [mango][9] and
  [river][10] that I'm experimenting with.
- [Kitty terminal][11].
- [Nushell][12] which is a joy to use.
- Git configuration with three-way neovim mergetool, [delta][13] and [difftastic][14] for
  prettier or more semantic diff highlighting, [gitui][15] TUI git client, and many aliases.
- Offline synchronized, Oauth compatible, terminal-based, keyboard driven email setup.
  Through [mbsync][16] and [earc][17], among other tools.
- Plain-text accounting with [hledger][18].
- [Neovim][19].
- Advanced keyboard customization on all platforms.
- [Btrfs][24] for transparent compression, and encryption-at-rest, through [disko][20].
- [fd][20], [ripgrep][21], [sd][22], [bat][30], [fzf][23] modern high-power CLI tools.
- [cmus][25] and [lyrical-rs][26] for music in the terminal.
- Screenlocker, cpu clockspeed, and idle management for laptop.
- [Librewolf][27] to mitigate web tracking to some extent, with [vim emulation][28].
- Consistent theming through [stylix][29].
- [XDG base directory][31] paths for all the programs that can be coaxed to use them.

[8]: https://github.com/hyprwm/Hyprland
[9]: https://github.com/DreamMaoMao/mangowc
[10]: https://codeberg.org/river/river
[11]: https://github.com/kovidgoyal/kitty
[12]: https://www.nushell.sh/
[13]: https://github.com/dandavison/delta
[14]: https://github.com/Wilfred/difftastic
[15]: https://github.com/gitui-org/gitui
[16]: https://isync.sourceforge.io/mbsync.html
[17]: https://aerc-mail.org/
[18]: https://hledger.org/index.html
[19]: https://github.com/raymon-roos/neovim-config
[20]: https://github.com/sharkdp/fd
[21]: https://github.com/BurntSushi/ripgrep
[22]: https://github.com/chmln/sd
[23]: https://github.com/junegunn/fzf
[24]: https://btrfs.readthedocs.io/en/latest/
[25]: https://github.com/cmus/cmus
[26]: https://github.com/raymon-roos/lyrical-rs
[27]: https://librewolf.net/
[28]: https://github.com/tridactyl/tridactyl
[29]: https://github.com/nix-community/stylix
[30]: https://github.com/sharkdp/bat
[31]: https://specifications.freedesktop.org/basedir-spec/latest/
