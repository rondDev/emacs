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
  :config
  (setq evil-collection-magit-use-z-for-folds t
        evil-collection-magit-use-y-for-yank t
        evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init)
  (setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes)))

(package! evil-goggles)

(package! evil-nerd-commenter
  :config
  (evilnc-default-hotkeys))

(package! evil-surround
  :config
  (global-evil-surround-mode 1))

(package! evil-snipe)


(package! exec-path-from-shell
  :init
  (when (file-executable-p "/usr/sbin/fish")
    (setq exec-path-from-shell-arguments ""))
  :config
  (add-hook 'emacs-startup-hook #'exec-path-from-shell-initialize))

(package! helpful
  :defer 10)

;; (package! multi-vterm
;;   :defer 15)

(package! on
  :defer 3)

(package! orderless
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-overrides '((file (styles partial-completion))))
  (setq completion-category-defaults nil)
  (setq completion-pcm-leading-wildcard t))

(package! persistent-scratch
  :config
  (persistent-scratch-setup-default))

;; NOTE: Could consider adding popper.
;; https://github.com/karthink/popper

(package! persp-projectile
  :after (projectile)
  :config
  (setq persp-mode-prefix-key "SPC.")
  (persp-mode))

(package! perspective
  :config
  (defun persp-new (name)
    "Return a perspective named NAME, or create a new one if missing.
The new perspective will start with only an `initial-major-mode'
buffer called \"*scratch* (NAME)\"."
    (or (gethash name (perspectives-hash))
        (make-persp :name name
          (persp-reset-windows)))))

(package! projectile
  :hook (elpaca-after-init)
  :init
  (setq projectile-project-search-path '("~/external/" "~/internal/" "~/code" "~/.config" ("~/projects" . 2))
        projectile-enable-caching t
        projectile-sort-order 'recently-active)
  (projectile-mode +1)
  (add-hook 'elpaca-after-init-hook #'projectile-discover-projects-in-search-path)
  (add-hook 'elpaca-after-init-hook #'projectile-load-known-projects))

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
  :defer 1
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config)) ;; add `smartparens-mode` to these hooks

(package! transient
  :defer t)

(package! undo-fu)
(package! undo-fu-session
  :hook (text-mode prog-mode)
  :init
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
  :ensure (vterm :post-build
                 (progn
                   (setq vterm-always-compile-module t)
                   (require 'vterm)
                   ;;print compilation info for elpaca
                   (with-current-buffer (get-buffer-create vterm-install-buffer-name)
                     (goto-char (point-min))
                     (while (not (eobp))
                       (message "%S"
                                (buffer-substring (line-beginning-position)
                                                  (line-end-position)))
                       (forward-line)))
                   (when-let* ((so (expand-file-name "./vterm-module.so"))
                               ((file-exists-p so)))
                     (make-symbolic-link
                      so (expand-file-name (file-name-nondirectory so)
                                           "../../builds/vterm")
                      'ok-if-already-exists))))
  :config
  (setq vterm-timer-delay nil
        vterm-max-scrollback 50000))



(package! wakatime-mode
  :config
  (when (file-executable-p "/usr/sbin/wakatime")
    (global-wakatime-mode)))
