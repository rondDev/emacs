;;; -*- lexical-binding: t -*-
(package! ace-window
  :after general)

(package! async
  :defer t)

(package! auth-source
  :ensure nil
  :defer t
  :custom (auth-sources '("~/.authinfo.gpg")))

(package! autorevert
  :ensure nil
  :defer 2)

(package! auto-sudoedit
  :defer 3)

(package! avy)

(package! complile
  :ensure nil
  :commands (compile recompile))

(package! consult)

(package! dired
  :ensure nil
  :commands (dired))

(package! editorconfig)

(package! emp
  :ensure (emp :host github :repo "progfolio/emp"))
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
  :after evil)

(package! evil-goggles
  :after (evil))

(package! evil-nerd-commenter
  :after (evil)
  :commands (evilnc-comment-or-uncomment-lines))

(package! evil-surround
  :after (evil))

;; (package! evil-vimish-fold
;;   :config
;;   (add-hook 'prog-mode-hook 'evil-vimish-fold-mode)
;;   (add-hook 'text-mode-hook 'evil-vimish-fold-mode))

(package! evil-quickscope
  :after (evil))

(package! exec-path-from-shell)

;; BUG: find-function--search-by-expanding-macros: Invalid escape char syntax: \A not followed by -
;; NOTE: Bug occurs after startup, seems to go away after opening a project
(package! helpful
  :defer 10)

;; (package! multi-vterm
;;   :defer 15)

(package! on
  :defer 3)

(package! orderless)

;; (package! persistent-scratch
;;   :init
;;   (persistent-scratch-setup-default))

;; NOTE: Could consider adding popper.
;; https://github.com/karthink/popper

(package! persp-projectile
  :after (projectile))

(package! perspective)

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
  (after! projectile
          (add-hook 'emacs-startup-hook #'projectile-git-autofetch-setup)))

(package! rg
  :defer 20)

(package! smartparens
  :defer 1
  :hook (prog-mode text-mode markdown-mode))

(package! transient
  :defer t)

(package! undo-fu)

(package! undo-fu-session
  :hook (text-mode prog-mode)
  :init
  (undo-fu-session-global-mode))

(package! vc-hooks
  :ensure nil
  :custom
  (vc-follow-symlinks t))

(package! vertico)

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

(package! wakatime-mode)
