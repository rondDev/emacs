;; -*- lexical-binding: t; -*-
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)
(add-hook 'js-ts-mode-hook #'eglot-ensure)

(after! eglot
        (rassq-delete-all 'typescript-ts-mode eglot-server-programs)
        (add-to-list 'eglot-server-programs
                     '((typescript-ts-mode js-mode) . ("rass" "ts"))))
;; (add-to-list 'eglot-server-programs
;;              '((typescript-ts-mode tsx-ts-mode js-ts-mode)
;;                . (eglot-deno "deno" "lsp")))
