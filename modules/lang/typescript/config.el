
(after! eglot
        (rassq-delete-all 'typescript-ts-mode eglot-server-programs)
        (add-to-list 'eglot-server-programs
                     '(typescript-ts-mode . ("rass" "ts"))))

(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
