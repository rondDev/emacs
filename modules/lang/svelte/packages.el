(package! typescript-mode
  :defer 10)

(package! svelte-ts-mode
  :after eglot
  :ensure (:host github :repo "leafOfTree/svelte-ts-mode"))
