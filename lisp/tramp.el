;;; Tramp
;; TRAMP performance settings
(setq tramp-use-ssh-controlmaster-options nil) ; Use your SSH config instead
(setq tramp-default-method "scp")             ; Force SSH method
(setq password-cache-expiry 3600)             ; Cache passwords longer

;; For faster connection establishment
(setq tramp-connection-timeout 10)
(setq tramp-verbose 3) ; Reduce if too verbose, increase for debugging
(setq remote-file-name-inhibit-locks t
      tramp-use-scp-direct-remote-copying t
      remote-file-name-inhibit-auto-save-visited t)
(setq tramp-copy-size-limit (* 8 1024 1024) ;; 8MB
      tramp-verbose 2)

(connection-local-set-profile-variables
 'remote-direct-async-process
 '((tramp-direct-async-process . t)))

(connection-local-set-profiles
 '(:application tramp :protocol "scp")
 'remote-direct-async-process)

(setq magit-tramp-pipe-stty-settings 'pty)

(with-eval-after-load 'tramp
  (with-eval-after-load 'compile
    (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options)))


(setq vterm-eval-cmds '(("find-file" find-file)
                        ("message" message)
                        ("vterm-clear-scrollback" vterm-clear-scrollback)
                        ("dired" dired)
                        ("ediff-files" ediff-files)))
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

(setq projectile-mode-line "Projectile")
