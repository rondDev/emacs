(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp/rond-util.el")))
(autoload 'package! (expand-file-name "lisp/rond-util.el" user-emacs-directory))
(autoload 'after! (expand-file-name "lisp/rond-util.el" user-emacs-directory))


(defvar evil-want-keybinding nil)
(defvar evil-kill-on-visual-paste nil)
(defvar evil-want-C-u-scroll t)
(defvar evil-want-C-i-jump nil)
(defvar evil-undo-system 'undo-fu)

(package! evil
  :ensure t
  :init
  :config
  (evil-mode)
  ;; Place the cursor in the new window after a horizontal split
  (setq evil-split-window-below t)
  ;; Place the cursor in the new window after a vertical split
  (setq evil-vsplit-window-right t))

(package! general
  :ensure (:wait t))


;;Turns off elpaca-use-package-mode current declaration
;; NOTE this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
(package! emacs :ensure nil :config (setq ring-bell-function #'ignore))
