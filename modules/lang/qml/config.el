
(after! qml-ts-mode
  ;; (add-to-list 'lsp-language-id-configuration '(qml-ts-mode . "qml-ts"))
  (add-to-list 'eglot-server-programs
    '(qml-ts-mode . ("qmlls6" "-E")))
  (add-hook 'qml-ts-mode-hook (lambda ()
                                (setq-local electric-indent-chars '(?\n ?\( ?\) ?{ ?} ?\[ ?\] ?\; ?,))
                                (eglot-ensure))))

