;;; -*- lexical-binding: t -*-
(package! forge
  :after magit
  :init (setq forge-add-default-bindings nil))

(package! ghub
  :after magit)

(package! magit
  :defer t
  :after general)

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
