---
layout: default
title: "setting up magit: git inside emacs"
date: 2026-02-18
---

# setting up magit: git inside emacs

this is the first in a series of tutorials on building an advanced
emacs configuration one small step at a time. we're not going to
throw a finished `.emacs` file at you and say "good luck." we're
going to build it together, piece by piece, so you understand every
line of it.

before we can manage our configuration properly, we need version
control. and in emacs, that means magit.

magit is git inside emacs. not a wrapper, not a gimmick — a complete
git interface that makes you wonder why you ever used the command line
for this. it also happens to be the best argument for emacs i know of.

## prerequisites

you need git installed at the system level first. emacs can't do this
for you.

on ubuntu:
```bash
sudo apt install git
```

on mac:
```bash
xcode-select --install
```

once git is installed, restart emacs — it needs to find git on your PATH.

## set up MELPA

magit doesn't ship with emacs. you need MELPA, the main emacs package
repository. add this to your `~/.emacs` or `~/.emacs.d/init.el`:
```elisp
;; === PACKAGE MANAGEMENT ===
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
```

restart emacs or `M-x eval-buffer`.

## install magit
```
M-x package-install RET magit RET
```

emacs will fetch and install it. takes a moment.

## tell git who you are

before you commit anything, git needs your identity. run this in a terminal:
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

use the email associated with your github account.

## set up SSH keys

github no longer accepts passwords. SSH keys are the clean solution.

generate a key:
```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

copy your public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

add it to github: settings → SSH and GPG keys → new SSH key → paste.

## clone a repo with magit
```
M-x magit-clone
```

paste your SSH repo URL when prompted. pick a local destination. done.

## the commit and push loop

this is what you'll use ten thousand times:
```
M-x magit-status
```

- **`s`** — stage a file (like `git add`)
- **`c c`** — open commit message buffer. write your message. `C-c C-c` to confirm.
- **`P p`** — push to origin.

that's it. that's the whole loop.

## update your remote to use SSH

if you cloned via HTTPS, switch it:
```bash
cd ~/your-repo
git remote set-url origin git@github.com:yourusername/your-repo.git
```

now magit pushes without ever asking for a password.

---

next up: making emacs *not* look like it hates you — starting with the theme.