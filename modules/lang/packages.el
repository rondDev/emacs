(package! corfu
  :init
  (global-corfu-mode))

(package! cape
  :init)
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...


(package! consult-eglot)
(package! dumb-jump) ;; dumb-jump is jump to definition for 50+ languages
(package! eglot)
(elpaca (eglot-booster :host github :repo "jdtsmith/eglot-booster" :init (eglot-booster-mode 1)))
(package! flycheck-eglot)
(package! flymake)
(package! jsonrpc)
(package! parinfer-rust-mode
  :hook emacs-lisp-mode)
(package! tempel ;; templates
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert)
         ("S-C-y" . tempel-insert)))
(package! tempel-collection)
