#!/bin/bash

# Installs Homebrew, Git, git-extras, git-friendly, hub, Node.js, configures Apache, PHP, MySQL, etc.

# Ask for the administrator password upfront
sudo -v

# Install Homebrew
command -v brew >/dev/null 2>&1 || ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
brew install tree
brew install wget
brew install curl

# More recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Git
brew install git
brew install git-extras

# Python
brew install python

# Ansible
brew install ansible

# Sshuttle
brew install sshuttle

# Install virtualenv
pip install virtualenv
pip install virtualenvwrapper

# Vim
brew install vim

# Slackcat
brew install slackcat

# Remove outdated versions from the cellar
brew cleanup
