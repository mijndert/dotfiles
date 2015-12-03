#!/bin/bash

# Installs virtualenv and virtualenvwrapper and installs the pip requirements

# source virtualenvwrapper again because of weirdness
source /usr/local/bin/virtualenvwrapper.sh

# create virtualenv dev
mkvirtualenv dev

# install requirements
pip install -Ur pip_requirements.txt
