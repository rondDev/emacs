;; -*- lexical-binding: t; -*-
(after! eglot
        (add-to-list 'eglot-server-programs
                     '(go-ts-mode . ("gopls")))
        (add-hook 'go-ts-mode-hook #'eglot-ensure))
