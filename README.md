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

if you add new file 
'''
$ git status                   # see it's untracked
$ git add README.md            # stage it (or `git add -A` to stage everything)
$ git commit -m "Add README"
$ git push
'''

then to push it to git hub 
'''
$ git push -u origin main
'''


## to push to gitHub
🧩 Option 1 — Fine-grained Personal Access Token (Recommended)

(This is GitHub’s newer model — safer and more specific.)

When creating it:

Repository access:

Choose “Only select repositories”

Then select pk-codes-99/dotfiles

Repository permissions:
Enable these:

✅ Contents: Read and write

✅ (Optional) Metadata: Read-only (automatically enabled)

❌ Everything else can stay No access

That’s all you need for basic Git push/pull.

So the table looks like:

Permission	Access	Why
Contents	Read & write	Needed for git push, git pull, etc.
Metadata	Read-only	Required implicitly for repo info
Others (issues, workflows, etc.)	No access	Not needed

✅ Then use it like this:

When Git asks:

Username for 'https://github.com': pk-codes-99
Password for 'https://pk-codes-99@github.com':


→ paste the token as the password.



## refer --> https://www.youtube.com/watch?v=y6XCebnB9gs
