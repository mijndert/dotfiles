#!/bin/bash
# Installs Bash 4 and registers it as a default shell

brew install bash bash-completion
grep -Fxq '/usr/local/bin/bash' /etc/shells || sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
chsh -s /usr/local/bin/bash $USER
