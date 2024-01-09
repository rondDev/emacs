(use-package evil
  :ensure t
             :general
             (rond/leader-keys
               "w" '(:keymap evil-window-map :wk "window"))
             :straight t
             :init
              (setq evil-want-keybinding nil)
             :config
              (evil-mode 1)
              (evil-set-initial-state 'messages-buffer-mode 'normal)
              (evil-set-initial-state 'dashboard-mode 'normal)
              (evil-set-initial-state 'magit-diff-mode 'insert)
              (evil-set-initial-state 'eshell-mode 'insert))

(use-package evil-collection
             :ensure t
             :config
             (evil-collection-init))

(provide 'use-evil)
