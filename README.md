# My dotfiles

This directory contains the dotfile for my system

## Requirments

Ensure you have following installed on your system

### Git

'''
pacman -S stow
'''

## Installation

First, check out the dotfiles repo in your $HOME directory using git
'''
$ git clone https://github.com/pk-codes-99/dotfiles.git
$ cd dotfiles
'''

then use stow to create symlinks

'''
$ stow .
'''

refer --> https://www.youtube.com/watch?v=y6XCebnB9gs
