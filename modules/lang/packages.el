;; TODO: Make apheleia use deno for svelte
(package! apheleia
  :init
  (apheleia-global-mode +1))



(package! company)

(package! corfu
  :disabled t
  :init
  (global-corfu-mode))

(package! caddyfile-mode
  :defer 12)

(package! cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev
            (add-hook 'completion-at-point-functions #'cape-file)
            (add-hook 'completion-at-point-functions #'cape-elisp-block)))
;; Add to the global default value of `completion-at-point-functions' which is
;; used by `completion-at-point'.  The order of the functions matters, the
;; first function returning a result wins.  Note that the list of buffer-local
;; completion functions takes precedence over the global list.
;; (add-hook 'completion-at-point-functions #'cape-history)
;; ...

(package! consult-eglot
  :defer 10
  :after consult)

(package! direnv
  :defer 10
  :config
  (direnv-mode))

;; dumb-jump is jump to definition for 50+ languages
(package! dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(package! eglot
  :defer 3)

(elpaca (eglot-booster
         :host github
         :repo "https://github.com/jdtsmith/eglot-booster"
         :after eglot
         :defer 3
         :config (eglot-booster-mode)))


(package! eglot-tempel
  :defer 3
  :after eglot)

(package! flycheck-popup-tip
  :defer 10)

(package! flycheck-eglot
  :defer 3
  :after eglot)

(package! flymake
  :defer 10)

(package! flyover
  :disabled t
  :hook (prog-mode))

(package! flycheck-eglot
  :after eglot
  :defer 3
  :ensure nil
  :hook (eglot-managed-mode . flycheck-eglot-mode)
  :custom (flycheck-eglot-exclusive nil))

(package! jsonrpc
  :defer 3)

(use-package lsp-mode
  :ensure t
  :hook ((js-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (svelte-mode . lsp-deferred)))

;; TODO: Move or refactor this
;;;###autoload
(defun rond/deno-add ()
  "Run `compile' in the project root with `command'."
  (interactive)
  (let ((default-directory (project-root (project-current t))))
    (let ((r (read-string "Command to run: " "deno add ")))
      (compile r))))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  ;; Sideline configuration
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover t)

  ;; (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-include-signature t)
  ;; Flycheck integration
  ;; (lsp-ui-flycheck-list-position 'bottom)
  :bind
  (:map lsp-ui-mode-map
        ("C-c C-j" . lsp-ui-peek-find-definitions)
        ("C-c i"   . lsp-ui-peek-find-implementation)))


(package! parinfer-rust-mode
  :hook emacs-lisp-mode)

(package! tempel ;; templates
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert)
         ("S-C-y" . tempel-insert)))

(package! tempel-collection
  :after 'tempel)

(package! tree-sitter-langs
  :defer t)

(package! yasnippet
  :disabled t
  :defer t)

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/lang/*/*.el")))
(load (expand-file-name "modules/lang/config.el" user-emacs-directory))
