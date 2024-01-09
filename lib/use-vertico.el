(use-package vertico
             :ensure t
             :init
             (setq vertico-resize t)
             (setq vertico-cycle t)
             (setq vertico-count 30))


;; Configure directory extension.
(use-package vertico-directory
             :after vertico
             :ensure nil ;; if this is set to true, it errors
             ;; More convenient directory navigation commands
             :bind (:map vertico-map
                         ("RET" . vertico-directory-enter)
                         ("DEL" . vertico-directory-delete-char)
                         ("M-DEL" . vertico-directory-delete-word))
             ;; Tidy shadowed file names
             :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(provide 'use-vertico)
