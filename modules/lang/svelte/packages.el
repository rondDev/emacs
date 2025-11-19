(package! web-mode)
  

(package! typescript-mode
  :defer 10)

(package! svelte-mode
  ;; :after eglot
  :mode "\\.svelte\\'"
  :config
  ;; (add-hook 'svelte-mode-hook #'eglot-ensure)
  ;; (add-hook 'svelte-mode-hook #'eglot-booster-mode)
  :ensure (:host github :repo "leafOfTree/svelte-mode"))

;; (package! svelte-ts-mode
;;   :mode "\\.svelte\\'"
;;   :ensure (:host github :repo "leafOfTree/svelte-ts-mode"))
