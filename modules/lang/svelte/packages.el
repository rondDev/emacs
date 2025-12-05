;;; -*- lexical-binding: t -*-
(package! lsp-tailwindcss
  :after lsp-bridge
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(package! web-mode
  :defer t)

(package! typescript-mode
  :disabled t
  :defer 10)

(package! svelte-mode
  :disabled t
  ;; :after eglot
  :mode "\\.svelte\\'"
  :config
  ;; (add-hook 'svelte-mode-hook #'eglot-ensure)
  ;; (add-hook 'svelte-mode-hook #'eglot-booster-mode)
  :ensure (:host github :repo "leafOfTree/svelte-mode"))

;; (package! svelte-ts-mode
;;   :mode "\\.svelte\\'"
;;   :ensure (:host github :repo "leafOfTree/svelte-ts-mode"))
