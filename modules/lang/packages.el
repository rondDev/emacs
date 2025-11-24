;; TODO: Make apheleia use deno for svelte
(package! apheleia
  :init
  (apheleia-global-mode +1))



(package! company)

(package! corfu
  :disabled t
  :init
  (global-corfu-mode)
  :config
 (setq corfu-auto t
              corfu-auto-delay 0.1
              corfu-auto-trigger "." ;; Custom trigger characters
              corfu-quit-no-match 'separator
              corfu-auto-prefix 2
              corfu-popupinfo-delay '(0.5 . 0.5)
              ;; NOTE: Might re-enable soemtime in the future
              text-mode-ispell-word-completion nil)
 (corfu-popupinfo-mode)
  
 (keymap-set corfu-map "TAB" nil)
 (keymap-set corfu-map "RET" nil))

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

(defvar rond/prog-mode-hook nil
  ;; TODO: Remember to add to this hook
  "Custom prog mode hook to enable more granular control")

(package! eglot
  :config
  (add-to-list 'eglot-server-programs
           '(svelte-mode . ("svelteserver" "--stdio"))))

(elpaca (eglot-booster
          :host github
          :repo "https://github.com/jdtsmith/eglot-booster"
          :after eglot
          :config (eglot-booster-mode)))


(package! eglot-tempel
  :after eglot
  :config
  (eglot-tempel-mode t))

(package! flycheck-popup-tip)

(package! flycheck-eglot
  :after eglot)

(package! flymake
  :defer 10)

(package! flyover
  :config
  (setq flyover-debounce-interval 0.1
    flyover-show-virtual-line nil
    flyover-show-at-eol t))

(package! flycheck-eglot
  :after eglot
  :ensure nil
  :hook (eglot-managed-mode . flycheck-eglot-mode)
  :custom (flycheck-eglot-exclusive nil))

(package! jsonrpc)

(use-package lsp-mode
  :ensure t
  :hook ((js-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (svelte-mode . lsp-deferred))
  :config
  ;; NOTE: Deno client will fail to start alot of the time
  ;;       so in that situation, reverting the buffer usually helps
 (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("deno" "lsp"))
                    :activation-fn (lsp-activate-on "svelte")
                    :add-on? t  ; This is the crucial flag
     :server-id 'deno-for-svelte))
 (add-to-list 'warning-suppress-log-types '(lsp-mode))
 (add-to-list 'warning-suppress-types '(lsp-mode))) 
 
  
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  ;; Sideline configuration
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics nil)
  (lsp-ui-sideline-show-hover t)

  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-include-signature t)
  ;; Flycheck integration
  (lsp-ui-flycheck-list-position 'bottom)
  :bind
  (:map lsp-ui-mode-map
        ("C-c C-j" . lsp-ui-peek-find-definitions)
    ("C-c i"   . lsp-ui-peek-find-implementation))
  :config
  (after! eldoc
    (setq lsp-eldoc-enable-hover nil)))
  

(package! parinfer-rust-mode
  :hook emacs-lisp-mode
  :config
 (setq parinfer-rust-check-before-enable nil
              parinfer-rust-preferred-mode "smart"))

(package! tempel ;; templates
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert)
         ("S-C-y" . tempel-insert))
  :config
  (setq tempel-path (expand-file-name "templates" user-emacs-directory))
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.  `tempel-expand'
    ;; only triggers on exact matches. We add `tempel-expand' *before* the main
    ;; programming mode Capf, such that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions)))

    ;; Alternatively use `tempel-complete' if you want to see all matches.  Use
    ;; a trigger prefix character in order to prevent Tempel from triggering
    ;; unexpectly.
    ;; (setq-local corfu-auto-trigger "/"
    ;;             completion-at-point-functions
    ;;             (cons (cape-capf-trigger #'tempel-complete ?/)
    ;;                   completion-at-point-functions))
  

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
  

(package! tempel-collection
  :after 'tempel)

(package! tree-sitter-langs
  :defer t)

(package! yasnippet
  :defer t)

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/lang/*/*.el")))
