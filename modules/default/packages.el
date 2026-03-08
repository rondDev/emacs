;;; -*- lexical-binding: t -*-
(package! async
  :config
  (autoload 'dired-async-mode "dired-async.el" nil t)
  ;; make dired async
  (dired-async-mode 1)
  (async-bytecomp-package-mode 1))

(package! auth-source
  :ensure nil
  :defer t
  :custom (auth-sources '("~/.authinfo.gpg")))

(package! autorevert
  :ensure nil
  :defer 2
  :custom
  (auto-revert-interval 0.01 "Instantaneously revert")
  :config
  (global-auto-revert-mode t))

(package! auto-sudoedit
  :defer 3
  :config
  (auto-sudoedit-mode 1)) ; automatically open with sudo

(package! avy)

(package! complile
  :ensure nil
  :commands (compile recompile)
  :config
  (defun +compilation-colorize ()
    "Colorize from `compilation-filter-start' to `point'."
    (require 'ansi-color)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max))))
  (add-hook 'compilation-filter-hook #'+compilation-colorize))

(package! consult)


(package! dired
  :ensure nil
  :commands (dired)
  :custom
  (dired-mouse-drag-files t)
  (dired-listing-switches "-alh" "Human friendly file sizes.")
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-omit-files "\\(?:\\.+[^z-a]*\\)")
  :hook (dired-mode-hook . dired-omit-mode))

(package! editorconfig
  :defer 6
  :config
  (editorconfig-mode 1))

(package! emp
  :ensure (emp :host github :repo "progfolio/emp")
  :config
  :general)
;; (+general-global-application
;;  "v"  '(:ignore t :which-key "video/audio")
;;  "vQ" 'emp-kill
;;  "vf" '(:ignore t :which-key "frame")
;;  "vfb" 'emp-frame-back-step
;;  "vff" 'emp-frame-step
;;  "vi" 'emp-insert-playback-time
;;  "vo" 'emp-open
;;  "vO" 'emp-cycle-osd
;;  "v SPC" 'emp-pause
;;  "vs" 'emp-seek
;;  "vr" 'emp-revert-seek
;;  "vt" 'emp-seek-absolute
;;  "vv" 'emp-set-context
;;  "vS" 'emp-speed-set))

(package! evil-anzu
  :after (evil anzu))

(package! evil-collection
  :after (evil)
  ;; :init (setq evil-collection-setup-minibuffer t)
  :config
  (setq evil-collection-magit-use-z-for-folds t
        evil-collection-magit-use-y-for-yank t)
  (setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))
  (evil-collection-init))

(package! evil-goggles
  :after (evil))

(package! evil-nerd-commenter
  :after (evil)
  :config
  (evilnc-default-hotkeys))

(package! evil-surround
  :after (evil)
  :config
  (global-evil-surround-mode 1))

;; (package! evil-vimish-fold
;;   :config
;;   (add-hook 'prog-mode-hook 'evil-vimish-fold-mode)
;;   (add-hook 'text-mode-hook 'evil-vimish-fold-mode))


(package! evil-quickscope
  :config
  (evil-quickscope-always-mode))

(package! exec-path-from-shell
  :init
  :config
  (add-hook 'emacs-startup-hook #'exec-path-from-shell-initialize))

;; BUG: find-function--search-by-expanding-macros: Invalid escape char syntax: \A not followed by -
;; NOTE: Bug occurs after startup, seems to go away after opening a project
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
  :init
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
  :after (general)
  :init
  (setq projectile-project-search-path '("~/code" "~/.config" ("~/projects" . 2))
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

(package! undo-fu
  :config
  (setq undo-limit 67108864) ; 64mb.
  (setq undo-strong-limit 100663296) ; 96mb.
  (setq undo-outer-limit 1006632960)) ; 960mb. )

(package! undo-fu-session
  :hook (text-mode prog-mode)
  :init
  (undo-fu-session-global-mode))

(package! vc-hooks
  :ensure nil
  :custom
  (vc-follow-symlinks t))


(package! vertico
  :config
  (setq vertico-cycle t)
  (setq vertico-count 20)
  (setq vertico-resize nil)
  (vertico-mode)
  (setq ido-mode nil))



(package! vterm
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
  :commands (vterm vterm-other-window)
  :general
  (+general-global-application
   "t" '(:ignore t :which-key "terminal")
   "tt" 'vterm-other-window
   "t." 'vterm)
  :config
  (evil-set-initial-state 'vterm-mode 'insert))



(package! wakatime-mode
  :config
  (when (file-executable-p "/usr/sbin/wakatime")
    (global-wakatime-mode)))
