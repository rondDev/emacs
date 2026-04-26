;; -*- lexical-binding: t; -*-
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

(package! dirvish
  :defer t)

(package! editorconfig)

(package! evil-multiedit)

(package! helpful
  :commands helpful--read-symbol
  :init
  (setq apropos-do-all t)

  (global-set-key [remap describe-function] #'helpful-callable)
  (global-set-key [remap describe-command]  #'helpful-command)
  (global-set-key [remap describe-variable] #'helpful-variable)
  (global-set-key [remap describe-key]      #'helpful-key)
  (after! apropos
          ;; patch apropos buttons to call helpful instead of help
          (dolist (fun-bt '(apropos-function apropos-macro apropos-command))
            (button-type-put
             fun-bt 'action
             (lambda (button)
               (helpful-callable (button-get button 'apropos-symbol)))))
          (dolist (var-bt '(apropos-variable apropos-user-option))
            (button-type-put
             var-bt 'action
             (lambda (button)
               (helpful-variable (button-get button 'apropos-symbol))))))

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
