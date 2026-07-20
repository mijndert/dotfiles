# dotfiles

## Install command line tools

```shell
xcode-select --install
```

## Clone this repository

```shell
mkdir -p ~/dev/personal
cd ~/dev/personal
git clone git@github.com:mijndert/dotfiles.git
cd dotfiles
```

## Run script

```shell
./install.sh
```

App Store apps are installed by `brew bundle` via `mas`. Sign in to the App Store first.

## Container

```shell
brew services start container
container system kernel set --recommended
```
