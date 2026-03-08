;;; -*- lexical-binding: t -*-
(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp/rond-util.el")))
(autoload 'package! (expand-file-name "lisp/rond-util.el" user-emacs-directory))
(autoload 'after! (expand-file-name "lisp/rond-util.el" user-emacs-directory))

(package! cus-edit
  :ensure nil
  :custom
  (custom-file null-device "Don't store customizations"))

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
  (evil-mode))

(package! general
  :ensure (:wait t))


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

