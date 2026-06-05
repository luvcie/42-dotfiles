"Dotfiles" for 42 Paris, school is on Fedora now. Following this will get you zsh with plugins, neovim with clangd for C/C++, a tiling window manager, an app launcher, wezterm and a bunch of useful binaries, all without sudo.

## PaperWM + Gnofi

School machines run GNOME 48 on Wayland. I use PaperWM for tiling and Gnofi as an app launcher, both are GNOME extensions so they install to your home folder and persist across reboots.

PaperWM is not like i3, it's more like niri. Windows live on an infinite horizontal strip and you scroll between them, it's not a screen splitter.

Install PaperWM :

```sh
git clone --depth 1 --branch v50.0.1 https://github.com/paperwm/PaperWM.git \
  ~/.local/share/gnome-shell/extensions/paperwm@paperwm.github.com
```

Install Gnofi, grab `gnofi@aylur.shell-extension.zip` from [releases](https://github.com/Aylur/gnofi-gnome-extension/releases) :

```sh
unzip gnofi@aylur.shell-extension.zip -d ~/.local/share/gnome-shell/extensions/gnofi@aylur
glib-compile-schemas ~/.local/share/gnome-shell/extensions/gnofi@aylur/schemas/
```

Log out and back in, then enable both :

```sh
gnome-extensions enable paperwm@paperwm.github.com
gnome-extensions enable gnofi@aylur
```

To open PaperWM settings and customize keybindings :

```sh
gnome-extensions prefs paperwm@paperwm.github.com
```

Full keybind list [here](https://github.com/paperwm/PaperWM?tab=readme-ov-file#keybindings). The important ones :

| Keybind | Action |
|---|---|
| `Super+Enter` | open terminal (wezterm, custom binding) |
| `Super+D` | app launcher (Gnofi, custom binding) |
| `Super+Backspace` | close window |
| `Shift+Super+F` | toggle fullscreen |
| `Super+F` | maximize width |
| `Super+. / Super+,` | focus next / previous window |
| `Super+Left / Right` | focus window left / right |
| `Super+Ctrl+Left / Right` | move window left / right |
| `Super+R` | resize window (cycles through widths) |
| `Super+C` | center window |
| `Super+I` | stack window below the active one in a column |

Set Super+D as the Gnofi trigger :

```sh
gsettings --schemadir ~/.local/share/gnome-shell/extensions/gnofi@aylur/schemas \
  set org.gnome.shell.extensions.gnofi window-hotkey "['<Super>d']"
```

Bind Super+Enter to open wezterm (replace YOUR_USERNAME) :

```sh
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/home/YOUR_USERNAME/.local/bin/wezterm'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>Return'
```

## Make zsh your default shell

School accounts are LDAP managed so `chsh` doesn't work. Add this at the top of your `~/.bashrc` instead :

```sh
[[ -x /usr/bin/zsh ]] && exec /usr/bin/zsh
```

## Install Oh My Zsh

```bash
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

This will override your `~/.zshrc` but it makes a backup in your home folder, just delete the new one and use your old one or the one in this repo. (Changing the username to yours.)

Plugins I use :

```sh
plugins=(
  zsh-vi-mode
  git
  zsh-syntax-highlighting
  colored-man-pages
  zsh-autosuggestions
  extract
)
```

Some plugins like zsh-vi-mode need to be cloned to `~/.oh-my-zsh/custom/plugins` too in order to work. Always remember to run `source ~/.zshrc` after installing a plugin.

## Starship prompt

```sh
curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin
```

Add this to your `~/.zshrc` :

```sh
eval "$(starship init zsh)"
```

For the starship preset I use, paste the `starship.toml` in this repo into `~/.config/starship.toml`. You will need a nerd font, download FiraCode from here : [FiraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip) and extract it to `~/.local/share/fonts`. I personally use FiraCode Nerd Font Bold Italic size 13.

## Binaries

No homebrew, no package manager. Make sure `~/.local/bin` is in your PATH :

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Just drop binaries there directly. Grab these from their GitHub releases pages : [neovim](https://github.com/neovim/neovim/releases), [zellij](https://github.com/zellij-org/zellij/releases), [zoxide](https://github.com/ajeetdsouza/zoxide/releases), [starship](https://github.com/starship/starship/releases), [fastfetch](https://github.com/fastfetch-cli/fastfetch/releases), [btop](https://github.com/aristocratos/btop/releases), [wezterm](https://github.com/wezterm/wezterm/releases) (grab the AppImage). I also have other stuff such as pfetch, bunnyfetch, compiledb, gemini-cli, etc.

Binaries won't show up in Gnofi or any app launcher unless they have a `.desktop` file. Create one for each app in `~/.local/share/applications/` :

```sh
cat > ~/.local/share/applications/zed.desktop << 'EOF'
[Desktop Entry]
Name=Zed
Comment=Code Editor
Exec=/home/YOUR_USERNAME/.local/bin/zed %F
Type=Application
Categories=Development;TextEditor;
EOF
```

Then run `update-desktop-database ~/.local/share/applications/` and it will show up immediately.

For zoxide add this to your `~/.zshrc` :

```sh
eval "$(zoxide init zsh)"
```

### Zed editor

Grab the `.tar.gz` from [releases](https://github.com/zed-industries/zed/releases), extract to `~/.local/zed` and symlink the binary :

```sh
ln -sf ~/.local/zed/bin/zed ~/.local/bin/zed
```

### WezTerm

Grab the AppImage from [releases](https://github.com/wezterm/wezterm/releases), drop it in `~/.local/bin/wezterm` and `chmod +x` it. By default it opens bash, create `~/.config/wezterm/wezterm.lua` to fix that :

```lua
local wezterm = require 'wezterm'

return {
  default_prog = { '/usr/bin/zsh' },
}
```

## npm globals without sudo

By default npm installs globally to `/usr/local` which needs root. Run this once :

```sh
npm config set prefix ~/.local
```

Now `npm install -g` drops binaries straight into `~/.local/bin`.

## Neovim

I use [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), clone it into `~/.config/nvim`.

`clangd` is already installed on school machines so you get C/C++ LSP for free. Just uncomment this in `init.lua` in the servers table :

```lua
clangd = {},
```

And add `cpp` to the treesitter `ensure_installed` list. To get proper includes and no false errors in your 42 projects, run this in the project root after building :

```sh
compiledb make
```

Install compiledb with pip :

```sh
pip install compiledb
```

## Yazi

To use yazi with `y` and have it change your working directory when you quit with q, add this to your `~/.zshrc` :

```sh
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
```

You can see hidden files by pressing `.` in yazi, delete files with `d`.

## Storage

The quota is 5GB. Things that eat it fast :

- Browser caches in `~/.config/`
- npm cache : `npm cache clean --force`

#### Why

I like to feel like home. This is not perfect but good enough to be comfy :)

Normally I bring my laptop but sometimes I have to work on the school machines and also do evaluations :p

---

*keeping this screenshot here as a good memory of the old Ubuntu setup with JuNest :)*

![old setup](https://i.ibb.co/6JKXnCZ/weew.png)
