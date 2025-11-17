;;; -*- lexical-binding: t -*-
(package! async)
(package! evil
 :init
 (setq evil-kill-on-visual-paste nil)
 (setq evil-want-C-u-scroll t)
 (setq evil-want-C-i-jump nil)
 (setq evil-undo-system 'undo-fu))
(package! undo-fu)
(package! evil-collection)
(package! evil-goggles)
(package! evil-nerd-commenter)
(package! evil-surround)
(package! evil-snipe)
(package! general)
(package! vertico)
(package! orderless)
;; Enable rich annotations using the Marginalia package
(package! marginalia
  :init
  ;; Needs to be called here for some reason
  (marginalia-mode)
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle)))

(package! nerd-icons-completion)

(package! nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(package! nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))


(package! persp-mode
  :init
  (persp-mode))

(package! projectile
  :defer t
  :init
  (setq projectile-project-search-path '("~/external/" "~/internal/" "~/code" ("~/projects" . 2))
        projectile-enable-caching t)
  (add-hook 'after-init-hook 'projectile-mode)
  (add-hook 'after-init-hook #'projectile-discover-projects-in-search-path))

(package! on)

(package! which-key)

(package! transient
  :defer t)
(package! rg
  :defer t)

(package! smartparens
  :defer t
  :hook (prog-mode text-mode markdown-mode)) ;; add `smartparens-mode` to these hooks
  
(package! rainbow-delimiters)

(package! helpful
  :defer t)
(package! consult
  :defer t)
(package! vterm
  :defer t)
(package! multi-vterm
  :defer t)

(package! avy)
