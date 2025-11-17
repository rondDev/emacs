(package! anzu)

(package! consult-todo) ; https://github.com/eki3z/consult-todo

(package! dashboard)

(package! doom-modeline)

(package! eldoc-box)

(package! flycheck-hl-todo) ; https://github.com/alvarogonzalezsotillo/flycheck-hl-todo
(package! hl-todo) ; https://github.com/tarsius/hl-todo

(package! magit-todos) ; https://github.com/alphapapa/magit-todos
;; Enable rich annotations using the Marginalia package
(package! marginalia
  :init
  ;; Needs to be called here for some reason
  (marginalia-mode)
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle)))

(package! nerd-icons)
(package! nerd-icons-completion)
(package! nerd-icons-corfu)
(package! nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))
(package! nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(package! page-break-lines)

(package! pulsar)

(package! rainbow-delimiters)

(package! rainbow-mode
  :hook (emacs-lisp-mode text-mode lisp-mode))

(package! spacious-padding
  :if (display-graphic-p)
  :hook (after-init . spacious-padding-mode)
  :bind ("<f8>" . spacious-padding-mode))

(package! which-key)
