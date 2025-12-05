;;; -*- lexical-binding: t -*-
;; (after! svelte-ts-mode
;;   (add-to-list 'eglot-server-programs '(svelte-ts-mode . ("svelteserver" "--stdio")))
;;   (add-hook 'svelte-ts-mode-hook #'web-mode))

;; (custom-set-faces
;;  '(flyover-error
;;    ((t :background "#453246"
;;        :foreground "#ea8faa"
;;        :height 0.9
;;        :weight normal)))

;;  '(flyover-warning
;;    ((t :background "#331100"
;;        :foreground "#DCA561"
;;        :height 0.9
;;        :weight normal)))

;;  '(flyover-info
;;    ((t :background "#374243"
;;        :foreground "#a8e3a9"
;;        :height 0.9
;;        :weight normal))))

;; (after! flyover
;;  (add-hook 'flycheck-mode-hook #'flyover-mode)
;;  (setq flyover-virtual-line-type 'curved-arrow
;;        flyover-percent-darker 60
;;        flyover-text-tint-percent 100
;;        flyover-text-tint 'lighter
;;        flyover-show-at-eol nil
;;        flyover-wrap-messages t
;;        flyover-max-lines 110
;;        flyover-debounce-interval 2.0
;;        flyover-background-lightness 20
;;        flyover-virtual-line-icon nil))

;; (defun init-mode-svelte ()
;;   (add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))
;;   (add-to-list 'eglot-server-programs '(svelte-mode . ("typescript-language-server" "--stdio"))))

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

;; (after! eglot
;;   (init-mode-svelte))


;; (add-hook 'svelte-ts-mode-hook #'eglot-ensure)
;; (add-hook 'svelte-ts-mode-hook #'flycheck-mode)
