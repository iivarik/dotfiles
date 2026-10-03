# .files

zsh + tmux + neovim (LazyVim) for Ubuntu / WSL.

```sh
git clone https://github.com/iivarik/dotfiles ~/workspace/dotfiles
~/workspace/dotfiles/install.sh            # everything
~/workspace/dotfiles/install.sh links      # or just some steps: packages | nvim | links | shell
```

Configs are symlinked into `~`, so edits in either place land in the repo.
Machine-specific shell settings go in `~/.zshrc.local` (not tracked).

## Nothing updates by itself

- **apt packages**: versions are fixed for the Ubuntu release.
- **neovim**: pinned by `NVIM_VERSION` in `install.sh`.
- **nvim plugins**: pinned by `.config/nvim/lazy-lock.json`; the update checker is off.
  To update: `:Lazy update`, try it out, commit `lazy-lock.json`.
  To roll back: `git checkout <old> -- .config/nvim/lazy-lock.json`, then `:Lazy restore`.
- **zsh / tmux**: no plugin managers. zsh plugins come from apt; tmux uses none.

## Terminal

Use a [Nerd Font](https://www.nerdfonts.com/) (e.g. JetBrainsMono Nerd Font) in Windows Terminal
for the icons in tmux and nvim. Copying (tmux `y`, nvim `"+y`) goes to the Windows clipboard via OSC 52.

## Keys worth remembering

| Key | What |
| --- | --- |
| `C-s` | tmux prefix |
| `prefix -` / `prefix _` | split below / right |
| `prefix space` / `bspace` | next / previous window |
| `C-h/j/k/l` | move between tmux panes and nvim splits |
| `F12` | turn local tmux keys off/on (to control a nested remote tmux) |
| `prefix r` | reload tmux config |
