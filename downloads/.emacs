;; Simple Emacs setup for Org-mode productivity

;; Enable CUA mode for normal cut/copy/paste
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't mess with indentation
(transient-mark-mode 1) ;; Highlighting works as expected
(setq cua-keep-region-after-copy t) ;; Standard copy behavior

;; Make paste (C-v) replace selected text
(delete-selection-mode 1)

;; Quick access to key help
(defun my-org-key-help ()
  "Show a quick popup of Org-mode function key shortcuts."
  (interactive)
  (message "F1: Help | F2: Org Agenda | F3: Cycle TODO | F4: Schedule | F5: Deadline | F7: Open File | F8: Save | F9: Save As | F10: Quit"))

(global-set-key (kbd "<f1>") 'my-org-key-help)  ;; F1 shows help

;; Org-mode workflow shortcuts
(global-set-key (kbd "<f2>") 'org-agenda)   ;; F2 opens the agenda
(global-set-key (kbd "<f3>") 'org-todo)     ;; F3 cycles TODO states
(global-set-key (kbd "<f4>") 'org-schedule) ;; F4 schedules a task
(global-set-key (kbd "<f5>") 'org-deadline) ;; F5 sets a deadline

;; File management
(global-set-key (kbd "<f7>") 'find-file)    ;; F7 opens files
(global-set-key (kbd "<f8>") 'save-buffer)  ;; F8 saves the file
(global-set-key (kbd "<f9>") 'write-file)   ;; F9 saves as (prompts for new name)
(global-set-key (kbd "<f10>") 'save-buffers-kill-terminal) ;; F10 quits Emacs

;; Log task completions automatically
(setq org-log-done t)
