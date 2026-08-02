;;; -*- lexical-binding: t -*-
(package! async
  :defer t)

(package! auth-source
  :ensure nil
  :defer t
  :custom (auth-sources '("~/.authinfo.gpg")))

(package! compat)

(package! eldoc-box)

(package! embark)
(package! embark-consult)

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

;; (package! multi-vterm
;;   :defer 15)

(package! on
  :defer 3)

(package! orderless)

;; NOTE: Could consider adding popper.
;; https://github.com/karthink/popper


(package! transient
  :defer t)

(package! undo-fu)

(package! undo-fu-session
  :hook (text-mode prog-mode)
  :init
  (undo-fu-session-global-mode))

(package! vertico)
