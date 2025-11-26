(package! forge
  :defer 12)
(package! ghub
  :defer 12)
(package! magit
  :general (:states '(normal visual motion)
                    :keymaps '(override magit-mode-map magit-status-mode)
                    "h" 'evil-backward-char
                    "j" 'evil-next-visual-line
                    "k" 'evil-previous-line
                    "l" 'evil-forward-char)
  
  
  :config
  (add-hook 'git-commit-mode-hook 'evil-insert-state)
  (evil-set-initial-state 'git-commit-mode 'insert)
  (evil-set-initial-state 'magit-status-mode 'normal)
  (setq-default magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1
                evil-collection-magit-use-z-for-folds t
                evil-collection-magit-use-y-for-yank t))

(package! tramp
  :ensure nil
  :defer 7)
