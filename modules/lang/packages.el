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


(package! tempel ;; templates
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert)
         ("S-C-y" . tempel-insert)))

(package! tempel-collection
  :after 'tempel)

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(package! tree-sitter-langs
  :defer t)

(package! yasnippet
  :defer t)

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/lang/*/*.el")))
(load (expand-file-name "modules/lang/config.el" user-emacs-directory))
