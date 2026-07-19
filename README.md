# dotfiles

Install command line tools

```shell
xcode-select --install
```

Clone this repository

```shell
mkdir -p ~/dev/personal
cd ~/dev/personal
git clone git@github.com:mijndert/dotfiles.git
cd dotfiles
```

Run script

```shell
./install.sh
```

App Store apps

- Things 3
- uBlock Origin Lite
- 1Password for Safari

Container

```shell
brew services start container
container system kernel set --recommended
```
