![screenshot](https://i.ibb.co/6JKXnCZ/weew.png)



Dotfiles to use at 42, following these instructions will give you neovim with plugins, a pretty shell with autocompletion, syntax highlighting and vim keybinds, and also access to package managers like homebrew and yay, yes, yay ^D^. The entire AUR.

## Install homebrew without sudo 
Run this in your home folder

```sh
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
```

Add homebrew to ~/.zshrc 

```sh
export PATH="/mnt/nfs/homes/YOURUSERNAME/homebrew/bin:$PATH"
```

Reload your .zshrc file

```sh
source ~/.zshrc
```

Packages to install with homebrew:

neovim, starship, zoxide, yazi

For zoxide add this to your .zshrc :

```sh
eval "$(zoxide init zsh)"
```

To configure starship, run this and paste the .toml in this repo. Or find your own here: [Starship presets](https://starship.rs/presets/)

```sh
starship config
```

For the starship preset I use, you will need a nerdfont installed in your system, to do this download it from here: [FiraCode](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip)

And extract it in /mnt/nfs/homes/USERNAME/.local/share/fonts

You can use this font in your terminal (the one you open with ctrl + alt + t, terminator, not the one from your launch bar.)
Right click inside the terminal --> Preferences --> Profiles --> General, uncheck Use the system fixed width font and choose FiraCode Nerd Font Bold Italic, I personally like size 13. You can also find more fonts here: 
[nerd fonts](https://www.nerdfonts.com/font-downloads)

To be able to use Yazi with "y" and have the ability to change the current working directory when exiting yazi with q, add this to your .zshrc

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

You can see hidden files by pressing "." in yazi, and you can delete files with "d".

## Install Oh my ZSH
```bash
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```
This will override your previous .zshrc file, but it will make a backup of your previous one in your home folder, just delete the new .zshrc and use the old one/the one in the repository. (Changing your username to yours.)

To install plugins you just have to add them to your .zshrc file like this:
```sh
plugins=(... git zsh-syntax-highlighting colored-man-pages zsh-autosuggestions extract))
```
Some plugins like zsh-vi-mode need to be cloned to ~/.oh-my-zsh/custom/plugins too in order to work.
Always remember to run ```source ~/.zshrc``` after installing a plugin.

## Install [lazyvim](http://www.lazyvim.org/) for nvim plugins
Make a backup of current neovim files, remember to delete it after to save space, you can also just skip this step.

```sh
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
```

Clone the starter in your nvim config file.

```sh
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

Remove the .git folder
```sh
rm -rf ~/.config/nvim/.git
```

Start neovim
```sh
nvim```


## Install JuNest (pacman, yay) without sudo.

JuNest (Jailed User Nest) is a lightweight Arch Linux that runs, without root privileges, on top of any other Linux distro.

Download Junest in your .local/share folder
```sh
git clone https://github.com/fsquillace/junest.git ~/.local/share/junest
```

Add these two lines to your .zshrc file.

```sh
export PATH=/mnt/nfs/homes/YOURUSERNAME/.local/share/junest/bin:$PATH
```

```sh
export PATH="$PATH:/mnt/nfs/homes/YOURUSERNAME/.junest/usr/bin_wrappers"
```

Reload your .zshrc file

```sh
source ~/.zshrc
```

Run 

```sh
junest setup
```

Update pacman and install base-devel to be able to install packages from the AUR with yay.

```sh
pacman -Syu
```

```sh
pacman -S base-devel
```

Install anything you want with yay :)

```sh
yay -S <package>
```

Now you can execute any package from your host OS shell, without even having to run junest first.

Keep in mind there's a storage limit of 5GB for your home, so don't install too much stuff. Right now I have 4.8 GB total. There's an option at 42 to upgrade it to 10GB with intranet points.

#### Why use homebrew when you have junest?

Some packages like starship or neovim don't work correctly with junest because they search the configuration files in a different place than they are supposed to.

#### Your 42 intra doesn't work or it's broken in all web browsers?

From your phone go to profile --> edit profile --> profile v3 --> leave profile v3

#### Why

I like to feel like home. 𖹭