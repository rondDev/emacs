;;; -*- lexical-binding: t -*-
(after! async
  (autoload 'dired-async-mode "dired-async.el" nil t)
  ;; make dired async
  (dired-async-mode 1)
  (async-bytecomp-package-mode 1))

(after! auto-sudoedit
  (auto-sudoedit-mode 1))

(after! avy
        (s-map!
         :keymaps '(normal visual motion)
         "s" #'avy-goto-char))

(setq evil-want-keybinding nil)
(after! evil
  (evil-mode)
  ;; Place the cursor in the new window after a horizontal split
  (setq evil-split-window-below t)
  ;; Place the cursor in the new window after a vertical split
  (setq evil-vsplit-window-right t)

  (after! evil-collection
    (evil-collection-init)
    (setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))))

(after! evil-nerd-commenter
  (evilnc-default-hotkeys))

(after! evil-surround
  (global-evil-surround-mode 1))

(after! editorconfig
        (editorconfig-mode 1))

(after! exec-path-from-shell
        (exec-path-from-shell-initialize))

;; (after! evil-snipe
;;         (evil-snipe-mode +1)
;;         (evil-snipe-override-mode +1)
;;         (setq evil-snipe-scope 'buffer))

(after! orderless
  (setq completion-styles '(orderless basic))
  (setq completion-category-overrides '((file (styles partial-completion))))
  (setq completion-category-defaults nil)
  (setq completion-pcm-leading-wildcard t))

(after! persistent-scratch
        (persistent-scratch-setup-default))

(after! persp-mode
        (setq persp-auto-resume-time 0)
        (add-hook 'after-init-hook #'(load (expand-file-name "lisp/projectile-persp.el" user-emacs-directory))
         (add-hook 'persp-mode-projectile-bridge-mode-hook
                   #'(lambda ()
                       (if persp-mode-projectile-bridge-mode
                           (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
                         (persp-mode-projectile-bridge-kill-perspectives))))
         (add-hook 'after-init-hook
                   #'(lambda ()
                       (persp-mode-projectile-bridge-mode 1))
                   t)))

(after! projectile
        (projectile-load-known-projects)
        (add-hook 'after-init-hook #'projectile-discover-projects-in-search-path))


(after! smartparens
        (require 'smartparens-config))

(after! vertico
  (setq vertico-cycle t)
  (setq vertico-count 20)
  (setq vertico-resize nil)
  (vertico-mode)
  (savehist-mode)
  (setq ido-mode nil)
  (s-map!
   :keymaps 'vertico-map
   "C-h" #'vertico-previous-group
   "C-l" #'vertico-next-group))


(after! wakatime-mode
  (global-wakatime-mode))

