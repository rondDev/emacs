(after! magit
  (evil-set-initial-state 'git-commit-mode 'insert)
  (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1))
