(use-package lsp-mode
             :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (XXX-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui 
             :ensure t
             :commands lsp-ui-mode)
;; if you are ivy user
(use-package lsp-ivy
             :ensure t
             :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
             :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode
             :ensure t)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(provide 'use-lsp)
