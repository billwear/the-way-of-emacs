---
layout: default
title: "Taming the UI: Making Emacs Not Look Like It Hates You"
date: 2026-02-19
---

# Taming the UI: Making Emacs Not Look Like It Hates You

Vanilla Emacs opens bright white, beeps at you, and wastes half your
screen on toolbars you'll never click. This is fixable. All of it,
in about twenty lines of Elisp.

This is the second post in a series on building an advanced Emacs
configuration one small step at a time. Each post adds one block to
your `~/.emacs` or `~/.emacs.d/init.el`. By the end of the series
you'll have a configuration you understand completely, because you
built it yourself.

## The UI Block

Add this to your init file:
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

Restart Emacs and the white screen is gone, the bell is silent, and
the clutter is cleared. What's left is just the editor.

## The Theme

**Surface:** `load-theme` switches Emacs to a dark color scheme.
`modus-vivendi` is the one to use.

**Component:** A theme in Emacs is a set of face definitions — colors
and fonts applied to every visual element in the editor. One call to
`load-theme` recolors everything at once: buffers, the modeline, the
minibuffer, syntax highlighting, all of it.

**Micro:** The `t` argument to `load-theme` means "don't ask for
confirmation." Without it, Emacs prompts you to approve the theme on
every startup, because themes can execute arbitrary Elisp. The `t`
tells Emacs you trust this theme. For built-in themes, that's always
safe.

**Quantum:** The reason Emacs defaults to white is the same reason
early GUIs defaulted to white: it mimicked paper. In 1984, screens
were the exotic thing and paper was the reference point. Forty years
later we stare at screens for eight hours a day, and the paper
metaphor is actively harmful. Dark themes aren't an aesthetic
preference — they're an ergonomic correction.

### A Note on Modus-Vivendi

`modus-vivendi` ships with Emacs 28 and later. It was designed
specifically for readability — high contrast without being harsh, and
it passes accessibility standards. If you're on an older Emacs,
`wombat` is a decent fallback:
```elisp
(load-theme 'wombat t)
```

## Fullscreen on Startup

**Surface:** Emacs opens maximized instead of in a small window.

**Component:** `initial-frame-alist` is a list of parameters applied
to the first frame Emacs creates. Adding `(fullscreen . maximized)`
to it tells Emacs to maximize that frame before displaying anything.

**Micro:** Emacs distinguishes between `maximized` and `fullscreen`.
Maximized fills the screen but keeps the window manager's decorations
and taskbar. Fullscreen takes over the entire display and hides
everything else. `maximized` is usually what you want — it plays
nicely with your desktop environment.

**Quantum:** The fact that you can specify frame parameters in a list
before Emacs draws anything is a consequence of Emacs's initialization
model: configuration runs before the display is fully realized. This
is why your init file can shape the environment rather than just
modify it after the fact. Emacs doesn't present you with a default and
ask you to override it. It asks you what you want before it builds
anything.

## The Bell

**Surface:** `(setq ring-bell-function 'ignore)` turns off the
audible and visual bell.

**Component:** Emacs uses the bell to signal errors and boundary
conditions — end of buffer, failed search, invalid command. By
default it either beeps or flashes the screen. Setting
`ring-bell-function` to `ignore` replaces that behavior with nothing.

**Micro:** `ring-bell-function` is a variable that holds a function.
When Emacs wants to ring the bell, it calls whatever function is
stored there. `ignore` is a built-in Emacs function that accepts any
arguments and does nothing. Assigning it here is not a hack — it's
exactly the intended mechanism.

**Quantum:** The bell exists because early terminals had no other way
to signal urgency — no color, no animation, no status bar. The beep
was the only out-of-band channel available. Modern Emacs has the
modeline, the echo area, and a full color display. The bell is
vestigial. Silencing it is not ignoring errors — it's removing noise
so signal can be heard.

## Clearing the Chrome

**Surface:** These three lines remove the toolbar, menu bar, and
scroll bar.
```elisp
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
```

**Component:** Each of these is a minor mode — a toggleable feature
of the Emacs display. Passing `-1` disables the mode. Passing `1`
enables it. They can be toggled interactively too, but setting them
in the init file means they're always off from the start.

**Micro:** The toolbar and menu bar duplicate functionality that is
faster to access via keybindings. The scroll bar duplicates
information already visible in the modeline — your position in the
buffer is shown as a percentage. None of them add capability. They
consume screen real estate that belongs to your text.

**Quantum:** The toolbar was added to Emacs in the late 1990s during
a period when GUIs were considered mandatory for mainstream software
adoption. It was a concession to convention, not a design choice.
Experienced Emacs users have always disabled it. The fact that it's
on by default is a historical artifact, not a recommendation.

## The Startup Screen

**Surface:** `(setq inhibit-startup-screen t)` skips the Emacs
welcome screen and opens directly to a buffer.

**Component:** The startup screen is an Emacs buffer that displays
version information, links to documentation, and a getting-started
guide. It's useful exactly once. After that it's just something
between you and your work.

**Micro:** `inhibit-startup-screen` is a boolean variable. Setting it
to `t` (true) tells Emacs to skip the startup buffer entirely and
open the `*scratch*` buffer instead — or whatever buffer you've
configured as your default.

**Quantum:** Every millisecond of friction between intention and
execution matters at the scale of a working day. The startup screen
is a small friction, but it's also a signal about whose interests the
default configuration serves. It serves new users who need
orientation. Once you're past that stage, your configuration should
serve you — and that means getting out of your way.

## Windmove and Window Creation

**Surface:** `Shift+arrow` moves between open windows. If there's no
window in that direction, Emacs creates one.

**Component:** Windmove is a built-in Emacs package for navigating
between windows using directional keystrokes. `windmove-default-keybindings`
binds it to `Shift+arrow`. `windmove-create-window` extends it to
create new windows at the edges of the frame.

**Micro:** Without `windmove-create-window`, pressing `Shift+right`
when there's no window to the right produces an error. With it, Emacs
splits the current window in the appropriate direction and moves point
into the new window. This requires Emacs 27 or later.

**Quantum:** Emacs's window model predates the concept of tabs and
predates most tiling window managers. The idea that an editor should
manage its own internal layout — multiple views into multiple buffers,
independently scrollable, arbitrarily arrangeable — was radical in
1976 and is still not universal in 2026. Windmove makes that model
navigable with muscle memory instead of key sequences. The `Shift+arrow`
binding is the only concession to modernity here. The underlying model
is fifty years old and still correct.

## Project Shortcuts

**Surface:** These functions let you jump to Magit for a specific
repo with a single keystroke from anywhere in Emacs.
```elisp
;; === PROJECT SHORTCUTS ===
(defun my/magit-way-of-emacs ()
  "Open Magit for the-way-of-emacs site."
  (interactive)
  (magit-status "~/the-way-of-emacs"))

(global-set-key (kbd "C-c e") 'my/magit-way-of-emacs)

(defun my/magit-billwear ()
  "Open Magit for billwear.github.io."
  (interactive)
  (magit-status "~/billwear.github.io"))

(global-set-key (kbd "C-c b") 'my/magit-billwear)
```

**Component:** Each `defun` defines a named function that calls
`magit-status` with a hardcoded path. `(interactive)` makes the
function callable via `M-x` and bindable to a key. `global-set-key`
binds it everywhere in Emacs, regardless of which mode is active.

**Micro:** The `my/` prefix is a naming convention, not syntax. It
namespaces your personal functions to avoid collisions with Emacs
internals and installed packages. Nobody else will define
`my/magit-way-of-emacs`. The slash is just a character — Elisp
symbols can contain it.

**Quantum:** The `C-c` prefix is reserved by Emacs convention for
user-defined keybindings. Emacs guarantees it will never use `C-c`
followed by a letter for built-in commands. This is not just courtesy
— it's part of the Emacs keybinding contract, documented in the
manual. Your configuration has a designated namespace in the keymap,
just as it has a designated namespace in the function registry. The
editor was designed to be extended. These conventions are the proof.

---

Next up: Package Management Beyond Magit — building out MELPA and
the packages that make Emacs genuinely useful for real work.