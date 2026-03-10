(after! eglot
        (add-to-list 'eglot-server-programs
                     '(scss-mode . ("some-sass-language-server" "--stdio"))))

(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
