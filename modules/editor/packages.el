(package! ace-window
  :after general)

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

(package! helpful
  :defer 10)

(package! rg
  :defer 20)

(package! smartparens
  :defer 1
  :hook (prog-mode text-mode markdown-mode))

(elpaca (term-toggle
         :host github
         :repo "rondDev/emacs-term-toggle"))

(package! vc-hooks
  :ensure nil
  :custom
  (vc-follow-symlinks t))

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
