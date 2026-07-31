;;; -*- lexical-binding: t -*-
(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp/rond-util.el")))
(autoload 'package! (expand-file-name "lisp/rond-util.el" user-emacs-directory))
(autoload 'after! (expand-file-name "lisp/rond-util.el" user-emacs-directory))

(package! autothemer)

(package! cus-edit
  :ensure nil
  :custom
  (custom-file null-device "Don't store customizations"))

(package! display-fill-column-indicator
  :ensure nil
  :custom
  (display-fill-column-indicator-character
    (plist-get '( triple-pipe  ?┆
                  double-pipe  ?╎
                  double-bar   ?║
                  solid-block  ?█
                  empty-bullet ?◦)
      'triple-pipe)))
;; :general
;; (+general-global-toggle
;;  "F" '(:ignore t :which-key "fill-column-indicator")
;;  "FF" 'display-fill-column-indicator-mode
;;  "FG" 'global-display-fill-column-indicator-mode)

(defvar evil-kill-on-visual-paste nil)
(defvar evil-undo-system 'undo-fu)

(package! evil
  :demand t
  :preface (setq evil-want-keybinding nil)
  :custom
  (evil-want-C-u-scroll t)
  (evil-complete-all-buffers nil)
  (evil-want-integration t)
  (evil-search-module 'evil-search "use vim-like search instead of 'isearch")
  (evil-want-C-i-jump t)
  (evil-shift-width 2 "Same behavior for vim's '<' and '>' commands")
  (evil-want-minibuffer t)
  (evil-ex-search-vim-style-regexp t)
  :hook
  (lisp-interaction-mode . (lambda () (setq-local evil-lookup-func #'+evil-lookup-elisp-symbol))) ; stolen from progfolio
  (emacs-lisp-mode . (lambda () (setq-local evil-lookup-func #'+evil-lookup-elisp-symbol))) ; stolen from progfolio

  :config
  ;; stolen from progfolio
  ;; TODO: bind this
  (defun +evil-lookup-elisp-symbol ()
    "Lookup elisp symbol at point."
    (if-let* ((symbol (thing-at-point 'symbol)))
      (describe-symbol (intern symbol))
      (user-error "No symbol at point")))
  ;; Place the cursor in the new window after a horizontal split
  ;; Place the cursor in the new window after a vertical split
  (setq evil-split-window-below t
    evil-vsplit-window-right t)
  (define-key evil-motion-state-map [down-mouse-1] nil)
  (evil-mode)
  (after! evil-collection
    (evil-collection-init)))


;;Turns off elpaca-use-package-mode current declaration
;; NOTE this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
(package! emacs
  :ensure nil
  :demand t
  :custom
  (scroll-conservatively 101 "Scroll just enough to bring text into view")
  (enable-recursive-minibuffers t "Allow minibuffer commands in minibuffer")
  (frame-title-format '(buffer-file-name "%f" ("%b"))
    "Make frame title current file's name.")
  (find-library-include-other-files nil)
  (indent-tabs-mode nil "Use spaces, not tabs")
  (inhibit-startup-screen t)
  (history-delete-duplicates t "Don't clutter history")
  (pgtk-use-im-context-on-new-connection nil "Prevent GTK from stealing Shift + Space")
  (sentence-end-double-space nil "Double space sentence demarcation breaks sentence navigation in Evil")
  (tab-stop-list (number-sequence 2 120 2))
  (tab-width 2 "Shorter tab widths")
  (completion-styles '(flex basic partial-completion emacs22))
  (report-emacs-bug-no-explanations t)
  (report-emacs-bug-no-confirmation t))

(package! files
  :ensure nil
  ;;:hook
  ;;(before-save . delete-trailing-whitespace)
  :config
  ;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
  (defun rename-file-and-buffer (new-name)
    "Renames both current buffer and file it's visiting to NEW-NAME."
    (interactive "sNew name: ")
    (let ((name (buffer-name)
            (filename (buffer-file-name))))
      (if (not filename)
        (message "Buffer '%s' is not visiting a file." name)
        (if (get-buffer new-name)
          (message "A buffer named '%s' already exists." new-name)
          (progn
            (rename-file filename new-name 1)
            (rename-buffer new-name)
            (set-visited-file-name new-name)
            (set-buffer-modified-p nil))))))
  :custom
  (require-final-newline t "Automatically add newline at end of file")
  (backup-by-copying t)
  (auto-save-file-name-transforms `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat rond-v/auto-save-folder "\\1") t)))
  (delete-old-versions t)
  (kept-new-versions 10)
  (kept-old-versions 5)
  (version-control t)
  (safe-local-variable-values
    '((eval load-file "./init-dev.el"
        (org-clean-refile-inherit-tags)))
    "Store safe local variables here instead of in emacs-custom.el")
  (lock-file-name-transforms `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat rond-v/lockfile-folder "\\1") t))))

(package! general
  :ensure (:wait t))
