# dotfiles

Install command line tools

```shell
xcode-select --install
```

Clone this repository

```shell
git clone git@github.com:mijndert/dotfiles.git
cd dotfiles
```

Run script

```shell
./install.sh
```

VS Code

- Open command palette > shell command
- Restart terminal session

```
DOTFILES_DIR=$(pwd)
ln -sf "$DOTFILES_DIR/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json
for i in $(cat vscode/vscode_extensions.txt); do code --install-extension "$i"; done
```