;;; -*- lexical-binding: t -*-
(package! async)

(package! auto-sudoedit) ; automatically open with sudo

(package! avy)

(package! consult
  :defer t)

(package! editorconfig)

(package! evil
 :init
 (setq evil-kill-on-visual-paste nil)
 (setq evil-want-C-u-scroll t)
 (setq evil-want-C-i-jump nil)
 (setq evil-undo-system 'undo-fu))
(package! evil-collection)
(package! evil-goggles)
(package! evil-nerd-commenter)
(package! evil-surround)
(package! evil-snipe)

(package! exec-path-from-shell)

(package! general)

(package! helpful
  :defer t)

(package! multi-vterm
  :defer t)

(package! on)

(package! orderless)

(package! persistent-scratch)

(package! persp-mode
  :init
  (persp-mode))

;; NOTE: Could consider adding popper.
;; https://github.com/karthink/popper

(package! projectile
  :defer t
  :init
  (setq projectile-project-search-path '("~/external/" "~/internal/" "~/code" ("~/projects" . 2))
        projectile-enable-caching t)
  (add-hook 'after-init-hook 'projectile-mode)
  (add-hook 'after-init-hook #'projectile-discover-projects-in-search-path))

(package! rg
  :defer t)

(package! smartparens
  :defer t
  :hook (prog-mode text-mode markdown-mode)) ;; add `smartparens-mode` to these hooks

(package! transient
  :defer t)

(package! undo-fu)
(package! undo-fu-session)


(package! vertico)

(package! vterm
  :defer t)

(package! wakatime-mode)
