(after! magit
        (def!
          :states '(normal visual motion)
          :keymaps '(override magit-mode-map magit-status-mode)
          "h" 'evil-backward-char
          "j" 'evil-next-visual-line
          "k" 'evil-previous-line
          "l" 'evil-forward-char)
        (add-hook 'git-commit-mode-hook 'evil-insert-state)
        (evil-set-initial-state 'git-commit-mode 'insert)
        (evil-set-initial-state 'magit-status-mode 'normal)
        (setq-default magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1
                      evil-collection-magit-use-z-for-folds t
                      evil-collection-magit-section-use-z-for-folds t
                      evil-collection-magit-use-y-for-yank t)
        (setq magit-clone-default-directory "~/code/")
        ;; magit-diff-visit-previous-blob nil)
        (transient-bind-q-to-quit))

(after! tramp
        (setq remote-file-name-inhibit-locks t
              remote-file-name-inhibit-auto-save-visited t))
