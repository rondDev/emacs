;;; -*- lexical-binding: t -*-

(rassq-delete-all 'js-mode auto-mode-alist)
;; (defun init-mode-svelte ())
(define-derived-mode svelte-mode web-mode "Svelte")


(defun rond/file-mode-hook ()
  (when (stringp buffer-file-name)
    (progn
      (when (string-match "\\.svelte\\'" buffer-file-name)
        ;; (init-mode-svelte)
        (svelte-mode))
      ;; TODO: Remove this
      (when (string-match "\\.ts\\'" buffer-file-name)
        (typescript-ts-mode)))))

(add-hook 'find-file-hook #'rond/file-mode-hook)

(after! eglot
        (add-to-list 'eglot-server-programs
                     '(svelte-mode . ("rass" "svelte"))))

(add-hook 'svelte-mode-hook #'eglot-ensure)

;; TODO consider
;; (setq eglot-ignored-server-capabilities
;;       '(:documentHighlightProvider :signatureHelpProvider))
