;;; -*- lexical-binding: t -*-
(package! async
  :config
 (autoload 'dired-async-mode "dired-async.el" nil t)
  ;; make dired async
 (dired-async-mode 1)
 (async-bytecomp-package-mode 1))

(package! auto-sudoedit
  :defer 3
  :config
 (auto-sudoedit-mode 1)) ; automatically open with sudo

(package! avy
  :defer 3)

(package! consult
  :defer 4)

(package! editorconfig
  :defer 6
  :config
  (editorconfig-mode 1))

(package! evil-collection
  :defer 3)

(package! evil-goggles
  :defer 8)

(package! evil-nerd-commenter
  :defer 8
  :config
 (evilnc-default-hotkeys))

(package! evil-surround
  :defer 8
  :config
 (global-evil-surround-mode 1))

(package! evil-snipe
  :defer 8)

(package! exec-path-from-shell
  :config
  (add-hook 'emacs-startup-hook #'exec-path-from-shell-initialize))

(package! helpful
  :defer 10)

(package! multi-vterm
  :defer 15)

(package! on
  :defer 3)

(package! orderless
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-overrides '((file (styles partial-completion))))
  (setq completion-category-defaults nil)
  (setq completion-pcm-leading-wildcard t))

(package! persistent-scratch
  :defer 10
  :config
         (persistent-scratch-setup-default))

(package! persp-mode
  :defer 5
  :init
  (persp-mode)
  :config
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

;; NOTE: Could consider adding popper.
;; https://github.com/karthink/popper

(package! projectile
  ;; :defer 3
  :init
  (setq projectile-project-search-path '("~/external/" "~/internal/" "~/code" "~/.config" ("~/projects" . 2))
        projectile-enable-caching t)
  (add-hook 'emacs-startup-hook 'projectile-mode)
  (add-hook 'emacs-startup-hook #'projectile-discover-projects-in-search-path)
  :config
  (projectile-load-known-projects))

(package! projectile-git-autofetch
  :after projectile
  :init
  (add-hook 'emacs-startup-hook #'projectile-git-autofetch-setup)
  :config
  (setopt projectile-git-autofetch-notify nil)
  (setopt projectile-git-autofetch-interval 60)
  (setopt projectile-git-autofetch-fetch-args '("--no-progress" "--prune" "--prune-tags")))
  
  

(package! rg
  :defer 20)

(package! smartparens
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config)) ;; add `smartparens-mode` to these hooks

(package! transient
  :defer t)

(package! undo-fu)
(package! undo-fu-session
  :config
  (undo-fu-session-global-mode))


(package! vertico
  :config
  (setq vertico-cycle t)
  (setq vertico-count 20)
  (setq vertico-resize nil)
  (vertico-mode)
  (setq ido-mode nil))
  

(package! vterm
  :defer 15
  :config
 (setq explicit-shell-file-name "/usr/bin/fish"))

(package! wakatime-mode
  :config
  (global-wakatime-mode))
