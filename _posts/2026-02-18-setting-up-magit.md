---
layout: default
title: "Setting Up Magit: Git Inside Emacs"
date: 2026-02-18
---

# Setting Up Magit: Git Inside Emacs

This is the first in a series of tutorials on building an advanced
Emacs configuration one small step at a time. We're not going to
throw a finished `.emacs` file at you and say "good luck." We're
going to build it together, piece by piece, so you understand every
line of it.

Before we can manage our configuration properly, we need version
control. And in Emacs, that means Magit.

**Surface:** Magit is a complete Git interface inside Emacs. Stage,
commit, push, branch, merge — all without leaving your editor.

**Component:** Magit sits between you and Git the way Emacs sits
between you and the operating system — it doesn't replace the
underlying tool, it gives you a better interface to it. Git still
does all the work. Magit just makes it visible and accessible.

**Micro:** Magit uses Emacs buffers to represent Git state. When you
open `magit-status`, you're looking at a live view of your repository
— staged files, unstaged changes, recent commits — all navigable with
standard Emacs keystrokes.

**Quantum:** Git was designed for the command line, which means it was
designed to be composed with other tools. Magit honors that design
while acknowledging that humans think spatially, not linearly. The
status buffer isn't a convenience wrapper — it's a genuinely better
representation of what Git is doing.

## Prerequisites

You need Git installed at the system level first. Emacs can't do this
for you.

**Surface:** Install Git before anything else.

On Ubuntu:
```bash
sudo apt install git
```

On Mac:
```bash
xcode-select --install
```

**Component:** Magit is an Emacs package, but it calls Git as an
external process. No Git, no Magit — regardless of what's installed
inside Emacs.

**Micro:** When Emacs starts, it builds a list of executables it can
find on your PATH. If Git isn't there at startup, Magit can't find
it. This is why you need to restart Emacs after installing Git —
not because anything changed inside Emacs, but because the PATH
snapshot needs to be retaken.

**Quantum:** This is the Unix philosophy at work. Emacs doesn't
bundle Git any more than Git bundles a text editor. Each tool does
one thing. They talk to each other through the operating system.
The interface is just a skin.

Once Git is installed, restart Emacs.

## Set Up MELPA

Magit doesn't ship with Emacs. You need MELPA, the main Emacs package
repository. Add this to your `~/.emacs` or `~/.emacs.d/init.el`:
```elisp
;; === PACKAGE MANAGEMENT ===
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
```

Restart Emacs or `M-x eval-buffer`.

**Surface:** MELPA is where you get packages. This tells Emacs it exists.

**Component:** Emacs ships with a package manager called `package.el`
and a default repository called ELPA. MELPA is a community-maintained
repository with a much larger selection. Adding it gives you access
to thousands of packages including Magit.

**Micro:** `add-to-list` appends MELPA to the existing list of
archives rather than replacing it. The `t` at the end means append
to the tail — ELPA stays first, MELPA is added behind it. This
matters for package priority when the same package exists in both.

**Quantum:** Package repositories in Emacs follow the same model as
system package managers — apt, brew, whatever you know. The
difference is that `package.el` is embedded in your editor rather
than your operating system. Your editor is the platform. This is not
an accident.

## Install Magit
```
M-x package-install RET magit RET
```

Emacs will fetch and install it. Takes a moment.

**Surface:** This downloads and installs Magit from MELPA.

**Component:** `package-install` fetches the package tarball from
MELPA, unpacks it into your Emacs package directory (usually
`~/.emacs.d/elpa/`), and byte-compiles it for performance.

**Micro:** Byte-compilation converts Emacs Lisp source into a faster
intermediate format. The `.elc` files you'll see in the package
directory are the compiled versions. Emacs loads these instead of the
raw `.el` files when available.

**Quantum:** Emacs Lisp is a real programming language, and Magit is
a real application written in it. When you install Magit, you're not
installing a plugin — you're installing a program that happens to run
inside your editor's runtime environment. This is why Emacs can do
things other editors can't: the editor and the application share the
same address space.

## Tell Git Who You Are

Before you commit anything, Git needs your identity. Run this in a
terminal:
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

Use the email associated with your GitHub account.

**Surface:** Git stamps every commit with your name and email. This
sets that stamp.

**Component:** These values are stored in `~/.gitconfig` and applied
globally to every repository on your machine. You can override them
per-repository with `--local` instead of `--global`.

**Micro:** When Magit opens the commit buffer, it reads these values
from Git's config and embeds them in the commit object. A commit
object in Git contains the tree hash, parent hash, author identity,
timestamp, and message — all of it cryptographically signed by the
resulting SHA.

**Quantum:** Identity in Git is not authentication — it's metadata.
Anyone can claim to be anyone in a commit message. What makes Git
trustworthy is not identity claims but cryptographic chaining: each
commit contains the hash of its parent, making history
tamper-evident. The name and email are for humans. The SHA is for
machines.

## Set Up SSH Keys

GitHub no longer accepts passwords. SSH keys are the clean solution.

Generate a key:
```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

Copy your public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

Add it to GitHub: Settings → SSH and GPG Keys → New SSH Key → paste.

**Surface:** This lets you push to GitHub without typing a password.

**Component:** SSH key authentication replaces password authentication
entirely. GitHub holds your public key. Your machine holds the private
key. When you push, they handshake and GitHub knows it's you.

**Micro:** Ed25519 is an elliptic curve algorithm. It produces shorter
keys than RSA with equivalent or better security, and it's faster to
verify. The `-C` flag adds a comment to the key — conventionally your
email — so you can identify it later in GitHub's key list.

**Quantum:** Public key cryptography is the same mathematics that
secures HTTPS, encrypted email, and cryptocurrency. The reason it
works is that multiplying two large primes is easy, but factoring the
result is computationally infeasible. Your private key is one of the
primes. Your public key is the product. GitHub can verify you have the
private key without you ever sending it across the wire.

## Clone a Repo with Magit
```
M-x magit-clone
```

Paste your SSH repo URL when prompted. Pick a local destination. Done.

**Surface:** This downloads a copy of a remote repository to your
machine.

**Component:** `magit-clone` wraps `git clone`. It prompts for the
URL and destination, runs the clone, and opens the resulting repo in
a Magit status buffer so you're ready to work immediately.

**Micro:** Cloning copies the entire repository history — every
commit, every branch, every tag — into a local `.git` directory. The
working tree is then checked out from the HEAD commit. You have a
complete, self-contained copy of the repository.

**Quantum:** This is one of Git's founding design decisions: every
clone is a full backup. Git was written by Linus Torvalds after
BitKeeper revoked the Linux kernel team's free license. He needed a
distributed system where no single server was authoritative. Every
developer's machine holds the full history. The server is
convenient, not essential.

## The Commit and Push Loop

This is what you'll use ten thousand times:
```
M-x magit-status
```

- **`s`** — Stage a file (like `git add`)
- **`c c`** — Open commit message buffer. Write your message. `C-c C-c` to confirm.
- **`P p`** — Push to origin.

**Surface:** Stage your changes, describe them, send them to GitHub.

**Component:** These three keystrokes map to the three phases of
Git's content-addressable workflow: selecting what to record,
describing the record, and synchronizing with the remote.

**Micro:** Staging adds file contents to Git's index — a snapshot of
what the next commit will contain. The commit creates a permanent
object in Git's object store with that snapshot plus your message and
identity. The push sends any local commits the remote doesn't have
yet, verified by comparing SHA chains.

**Quantum:** Git's three-stage model — working tree, index, commit —
is a direct consequence of its content-addressable storage design.
Files aren't stored as files in Git's object store; they're stored as
blobs, identified by SHA hashes of their content. The index lets you
build a commit incrementally, selecting exactly which content changes
to include. Most version control systems don't have this. It looks
like a complication until you understand why it exists.

## Update Your Remote to Use SSH

If you cloned via HTTPS, switch it:
```bash
cd ~/your-repo
git remote set-url origin git@github.com:yourusername/your-repo.git
```

Now Magit pushes without ever asking for a password.

**Surface:** This switches your repo from password authentication to
key authentication.

**Component:** A remote in Git is just a named URL. `origin` is the
conventional name for the primary remote — the one you cloned from.
`set-url` replaces the stored URL without touching your history or
working tree.

**Micro:** The difference between HTTPS and SSH URLs is not just
authentication — it's protocol. HTTPS goes through port 443 and
authenticates via credentials. SSH goes through port 22 and
authenticates via key exchange. Both transfer the same Git objects.

**Quantum:** The reason GitHub deprecated password authentication
over HTTPS is not security theater — plaintext passwords in
credential stores are a genuine attack surface. SSH keys live in
`~/.ssh` with permissions that prevent other users from reading them.
The private key never leaves your machine. This is a meaningfully
different security posture, not just a different login flow.

---

Next up: Making Emacs not look like it hates you — starting with the
theme.