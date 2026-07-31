;; -*- lexical-binding: t; -*-
(rassq-delete-all 'ruby-ts-mode auto-mode-alist)
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))

;; (after! apheleia
;;         (setf apheleia-formatters
;;               (assq-delete-all 'prettier-ruby apheleia-formatters))

;;         (push '(ruby-mode . rubocop) apheleia-mode-alist)
;;         (push '(ruby-ts-mode . rubocop) apheleia-mode-alist)
;;         (push '(rubocop . ("rubocop")) apheleia-formatters))

(after! eglot
        (add-to-list 'eglot-server-programs
                     '(ruby-mode . ("ruby-lsp"))))

(add-hook 'ruby-mode #'eglot-ensure)
