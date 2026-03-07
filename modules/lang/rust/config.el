;;; -*- lexical-binding: t -*-
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(after! eglot
        (add-to-list 'eglot-server-programs
                     '(rust-ts-mode . ("rass" "rust")))
        (add-hook 'rust-ts-mode #'eglot-ensure))


(setq rust-ts-mode-indent-offset 2)
