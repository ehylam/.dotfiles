1. Install Apple's Command Line Tools

```
xcode-select --install
```

2. Clone repo in to `~/` directory

```
git clone git@github.com:ehylam/.dotfiles.git
```

3. using `ln` link the files in the cloned repo with the files in the home directory

```
ln -s ~/.dotfiles/.config/fish ~/.config/fish
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
```

4. Install Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

5. run the Brewfile in the clone repo.

```
brew bundle --file ~/.dotfiles/Brewfile
```

6. Install Golang for "misspell" package
   https://go.dev/dl/
