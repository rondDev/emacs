;;; -*- lexical-binding: t -*-
(package! forge
  :after magit
  :init (setq forge-add-default-bindings nil))

(package! ghub
  :after magit)

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
  (setq tramp-use-ssh-controlmaster-options nil)
  (setq tramp-default-method "ssh")
  (setq tramp-methods
        (seq-remove (lambda (m) (member (car m) '("gdrive" "davs" "dav")))
                    tramp-methods))
  (setq tramp-connection-properties
        (append tramp-connection-properties
                '((nil "disable-ipv6" t)
                  (nil "suppress-progress-reporter" t)))))
