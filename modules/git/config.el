;; -*- lexical-binding: t; -*-
(after! forge
        (push '("gitssh.rond.cc"               ; GITHOST
                "git.rond.cc/api/v1"        ; APIHOST
                "git.rond.cc"               ; WEBHOST and INSTANCE-ID
                forge-gitea-repository)     ; CLASS

              forge-alist)
        (push '("git.rond.cc"               ; GITHOST
                "git.rond.cc/api/v1"        ; APIHOST
                "git.rond.cc"               ; WEBHOST and INSTANCE-ID
                forge-gitea-repository)     ; CLASS
              forge-alist))

(after! magit
        (def!
          :states '(normal visual motion)
          :keymaps '(override magit-mode-map magit-status-mode)
          "h" 'evil-backward-char
          "j" 'evil-next-visual-line
          "k" 'evil-previous-line
          "l" 'evil-forward-char)
        (add-hook 'git-commit-mode-hook 'evil-insert-state)
        (add-hook 'magit-status-sections-hook #'magit-insert-worktrees)
        (evil-set-initial-state 'git-commit-mode 'insert)
        (evil-set-initial-state 'magit-status-mode 'normal)
        (setq-default magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1
                      evil-collection-magit-use-z-for-folds t
                      evil-collection-magit-section-use-z-for-folds t
                      evil-collection-magit-use-y-for-yank t)
        (setq magit-clone-default-directory "~/code/")
        ;; magit-diff-visit-previous-blob nil)
        (transient-bind-q-to-quit)
        (defun rond/consult-git-worktree ()
          (interactive)
          (let* ((worktrees (shell-command-to-string "git worktree list --porcelain"))
                 (paths (cl-remove-if #'null
                                      (mapcar (lambda (line)
                                                (when (string-prefix-p "worktree " line)
                                                  (substring line 9)))
                                              (split-string worktrees "\n")))))
            (projectile-switch-project-by-name
             (completing-read "Worktree: " paths))))
        (general-spc
          "gw" '(rond/consult-git-worktree :wk "Switch to worktree"))
  (add-to-list 'display-buffer-alist
   '("^magit-diff:"
     (display-buffer-in-side-window)
     (side . right)
     (slot . 0)
     (window-width . 0.5)
     (inhibit-same-window . t))))

(after! tramp
        (setq remote-file-name-inhibit-locks t
              remote-file-name-inhibit-auto-save-visited t))

(after! git-link
        (setq git-link-default-remote "origin")
        (setq git-link-open-in-browser t)

        (add-to-list 'git-link-remote-alist
                     '("gitssh\\.rond\\.cc" git-link-codeberg))
        (add-to-list 'git-link-commit-remote-alist
                     '("gitssh\\.rond\\.cc" git-link-commit-codeberg))

        (add-to-list 'git-link-web-host-alist `("gitssh\\.rond\\.cc" . "git.rond.cc")))

