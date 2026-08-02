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

(package! ghostel
  :bind (("C-x m" . ghostel)
         :map ghostel-semi-char-mode-map
         ("C-s"  . consult-line)
         ("C-k"  . r/ghostel-send-C-k-and-kill)
         ;; I'm used to go up/down the shell history with M-n/p from eshell
         ;; Simulate this behavior in ghostel by sending C-p and C-n
         ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
         ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (defun r/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))

  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer))
  (setq ghostel-shell (cond
                        ((f-executable-p "/usr/bin/nu") "/usr/bin/nu")
                        ((f-executable-p "/usr/bin/zsh") "/usr/bin/zsh")
                        (t "/usr/bin/bash"))))

(package! evil-ghostel
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))
(package! ghostel-eshell
  :after (ghostel)
         :ensure nil
  :hook (eshell-load . ghostel-eshell-visual-command-mode))
(package! ghostel-compile
  :after (ghostel)
         :ensure nil
  :hook (after-init . ghostel-compile-global-mode))
(package! ghostel-comint
  :after (ghostel)
         :ensure nil
  :hook (after-init . ghostel-comint-global-mode))

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

(package! server
  :when (display-graphic-p)
  :ensure nil
  :config
  (when-let* ((name (getenv "EMACS_SERVER_NAME")))
    (setq server-name name)
    (unless (server-running-p)
      (server-start))))

(package! vc-hooks
  :ensure nil
  :custom
  (vc-follow-symlinks t))

(package! visual-regexp)
(package! visual-regexp-steroids
  :after 'general)

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
