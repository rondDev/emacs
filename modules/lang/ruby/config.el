;; -*- lexical-binding: t; -*-
(after! eglot
        (add-to-list 'eglot-server-programs
                     '(ruby-ts-mode . ("ruby-lsp")))
        (add-hook 'ruby-ts-mode #'eglot-ensure))
