;; -*- lexical-binding: t; -*-

(after! parinfer-rust-mode
  (setq parinfer-rust-check-before-enable nil
    parinfer-rust-preferred-mode "paren"))


;; (defun r/eldoc-full-docstring (callback)
;;   "Send the full documentation of the function/macro at point to ElDoc."
;;   (let ((sym (car (elisp--fnsym-in-current-sexp))))
;;     (when (and sym (fboundp sym))
;;       (funcall callback
;;                (with-temp-buffer
;;                  (let ((standard-output (current-buffer)))
;;                    (describe-function-1 sym))
;;                  (buffer-string))
;;                :thing sym
;;                :face 'font-lock-function-name-face))))

;; (defun r/get-full-doc ()
;;   (interactive)
;;   (let ((eldoc-documentation-functions '(r/eldoc-full-docstring
;;                                          elisp-eldoc-var-docstring
;;                                          elisp-eldoc-funcall
;;                                           t)))
;;     (eldoc-doc-buffer)))


;; (after! evil
;;   (def!
;;     :states '(normal visual motion)
;;     "C-k" #'r/get-full-doc))

;; (add-hook 'emacs-lisp-mode-hook
;;           (lambda ()
;;             (add-hook 'eldoc-documentation-functions #'r/eldoc-full-docstring nil t)))
