;; Enable auto completion, configure delay, trigger and quitting
(after! lsp-mode
        (add-hook 'web-mode-hook #'lsp))
;; (after! lsp-ui)
(after! flycheck)
        ;; (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)
        
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

(after! parinfer-rust-mode
        (setq parinfer-rust-check-before-enable nil
              parinfer-rust-preferred-mode "smart"))

(load (locate-user-emacs-file "modules/lang/svelte/packages.el"))
(load (locate-user-emacs-file "modules/lang/svelte/config.el"))
