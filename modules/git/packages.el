;;; -*- lexical-binding: t -*-
(package! forge
  :after magit
  :init (setq forge-add-default-bindings nil))

(package! ghub
  :after magit)

(package! git-link)

(elpaca (magit
         :host github
         :repo "magit/magit"
         :depth 1
         :after general)
  :defer t)

(package! tramp
  :ensure nil
  :defer t
  :init
  :config

  (setq tramp-verbose 0
        tramp-chunksize 2000
        tramp-use-ssh-controlmaster-options nil
        tramp-default-method "ssh"
        tramp-verbose 1
        tramp-default-remote-shell "/bin/sh"
        tramp-connection-local-default-shell-variables
        '((shell-file-name . "/bin/bash")
          (shell-command-switch . "-c")))
  (setq tramp-methods
        (seq-remove (lambda (m) (member (car m) '("gdrive" "davs" "dav")))
                    tramp-methods))
  (setq tramp-connection-properties
        (append tramp-connection-properties
                '((nil "disable-ipv6" t)
                  (nil "suppress-progress-reporter" t)))))
  ;; (setq vc-handled-backends '())
  ;; (setq vc-ignore-dir-regexp ".+"))
