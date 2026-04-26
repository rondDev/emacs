;; -*- lexical-binding: t; -*-
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(rassq-delete-all 'ruby-ts-mode auto-mode-alist)
(after! eglot
        (add-to-list 'eglot-server-programs
                     '(ruby-mode . ("ruby-lsp"))))

(add-hook 'ruby-mode #'eglot-ensure)
