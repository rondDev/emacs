        
(after! company
        (add-hook 'after-init-hook 'global-company-mode))
(after! corfu
        (setq corfu-auto t
              corfu-auto-delay 0.1
              corfu-auto-trigger "." ;; Custom trigger characters
              corfu-quit-no-match 'separator
              corfu-auto-prefix 2
              corfu-popupinfo-delay '(0.5 . 0.5))
        (corfu-popupinfo-mode)
        (general-define-key
         :package 'corfu
         :keymaps '(override corfu-map)
         "C-y" #'corfu-complete)
        (keymap-set corfu-map "TAB" nil)
        (keymap-set corfu-map "RET" nil))
        

(after! cape
        (add-hook 'completion-at-point-functions #'cape-dabbrev)
        (add-hook 'completion-at-point-functions #'cape-file)
        (add-hook 'completion-at-point-functions #'cape-elisp-block))

(after! dumb-jump
        (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(after! eglot-tempel
  (eglot-tempel-mode t))

(after! flycheck)
        ;; (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)

(after! parinfer-rust-mode
        (setq parinfer-rust-check-before-enable nil
              parinfer-rust-preferred-mode "smart"))

(after! tempel
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.  `tempel-expand'
    ;; only triggers on exact matches. We add `tempel-expand' *before* the main
    ;; programming mode Capf, such that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions)))

    ;; Alternatively use `tempel-complete' if you want to see all matches.  Use
    ;; a trigger prefix character in order to prevent Tempel from triggering
    ;; unexpectly.
    ;; (setq-local corfu-auto-trigger "/"
    ;;             completion-at-point-functions
    ;;             (cons (cape-capf-trigger #'tempel-complete ?/)
    ;;                   completion-at-point-functions))
  

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
        

(load (locate-user-emacs-file "modules/lang/svelte/packages.el"))
(load (locate-user-emacs-file "modules/lang/svelte/config.el"))
