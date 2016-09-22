#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Installs virtualenv and virtualenvwrapper and installs the pip requirements

pip install virtualenv
pip install virtualenvwrapper

# source virtualenvwrapper again because of weirdness
source /usr/local/bin/virtualenvwrapper.sh

# create virtualenv dev
mkvirtualenv dev

# install requirements
pip install -Ur pip_requirements.txt
