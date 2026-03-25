---
layout: default
title: "taming the ui: making emacs not look like it hates you"
date: 2026-02-19
---

# taming the ui: making emacs not look like it hates you

vanilla emacs opens bright white, beeps at you, and wastes half your
screen on toolbars you'll never click. this is fixable. all of it,
in about twenty lines of elisp.

this is the second post in a series on building an advanced emacs
configuration one small step at a time. each post adds one block to
your `~/.emacs` or `~/.emacs.d/init.el`. by the end of the series
you'll have a configuration you understand completely, because you
built it yourself.

## the ui block

add this to your init file:
```elisp
;; === UI ===
;; because vanilla emacs looks like it's auditioning for a horror film

;; dark theme -- eyes are not expendable
(load-theme 'modus-vivendi t)

;; start fullscreen
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; turn off the bell -- we are adults
(setq ring-bell-function 'ignore)

;; no toolbar, no menubar, no scrollbar -- we know what we're doing
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; no startup screen
(setq inhibit-startup-screen t)

;; move between windows with shift+arrow keys
;; and create a new window if there isn't one in that direction
(windmove-default-keybindings)
(setq windmove-create-window t)

;; show column number in modeline
(column-number-mode t)

;; highlight current line
(global-hl-line-mode t)
```

restart emacs and the white screen is gone, the bell is silent, and
the clutter is cleared. what's left is just the editor.

## a note on modus-vivendi

`modus-vivendi` ships with emacs 28 and later. it was designed
specifically for readability — high contrast without being harsh, and
it passes accessibility standards. if you're on an older emacs,
`wombat` is a decent fallback:
```elisp
(load-theme 'wombat t)
```

## windmove and window creation

`windmove-default-keybindings` gives you `shift+arrow` to move
between open windows. the second line is the important one:
`windmove-create-window` means that if you shift-arrow toward an
edge where there's no window, emacs creates one instead of
complaining. this requires emacs 27 or later.

## project shortcuts

while we're in the init file, let's add quick magit access for your
regular repos. the pattern is simple — one defun per project, one
keybinding per defun:
```elisp
;; === PROJECT SHORTCUTS ===
(defun my/magit-way-of-emacs ()
  "Open magit for the-way-of-emacs site."
  (interactive)
  (magit-status "~/the-way-of-emacs"))

(global-set-key (kbd "C-c e") 'my/magit-way-of-emacs)

(defun my/magit-billwear ()
  "Open magit for billwear.github.io."
  (interactive)
  (magit-status "~/billwear.github.io"))

(global-set-key (kbd "C-c b") 'my/magit-billwear)
```

one keystroke from anywhere in emacs drops you into magit for that
repo. add as many as you need. the `C-c` prefix is reserved by
convention for user keybindings — you won't step on anything emacs
owns.

---

next up: package management beyond magit — building out MELPA and
the packages that make emacs genuinely useful for real work.