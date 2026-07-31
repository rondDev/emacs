;;; -*- lexical-binding: t -*-
;; TODO: Make apheleia use deno for svelte
(package! apheleia
  :init
  (apheleia-global-mode +1))

;; (package! company)

(package! corfu
  :config
  (global-corfu-mode))

(package! caddyfile-mode
  :defer 12)

(package! cape)
;; Add to the global default value of `completion-at-point-functions' which is
;; used by `completion-at-point'.  The order of the functions matters, the
;; first function returning a result wins.  Note that the list of buffer-local
;; completion functions takes precedence over the global list.
;; (add-hook 'completion-at-point-functions #'cape-history)
;; ...

(package! consult-eglot
  :defer 10
  :after consult)

(package! devdocs
  :after general
  :defer t
  :commands (devdocs-lookup devdocs-install devdocs-peruse))

(package! direnv
  :defer 10)

;; dumb-jump is jump to definition for 50+ languages
(package! dumb-jump)

(package! eglot
  :ensure nil
  :hook ((rust-ts-mode . eglot-ensure)
          (go-ts-mode . eglot-ensure)))

(elpaca
  (eglot-booster :host github :repo "jdtsmith/eglot-booster" :after eglot)
  :custom
  :config
  (eglot-booster-mode) 
  (setq eglot-booster-io-only t))


(package! elisp-mode
  :ensure nil)

(package! hyprlang-ts-mode
  :hook (hyprlang-ts-mode-hook))


(package! markdown-mode
  :hook (markdown-mode-hook))

(package! nix-mode
  :hook (nix-mode-hook))

(package! qml-mode
  :hook (qml-mode-hook))

(package! tempel ;; templates
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert)
         ("S-C-y" . tempel-insert)))

(package! tempel-collection
  :after 'tempel)

(package! treesit-auto)

;; (package! treesit-fold
;;   :config
;;   (global-treesit-fold-mode))

(package! tree-sitter-langs
  :defer t)

;; (package! vimish-fold)

(package! yasnippet
  :init
  (add-hook 'prog-mode-hook #'yas-minor-mode)
  :commands (yas-global-mode))

(package! yasnippet-snippets
  :after (yasnippet))
(package! auto-yasnippet
  :after (yasnippet))

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/lang/*/*.el")))
(load (expand-file-name "modules/lang/config.el" user-emacs-directory))
