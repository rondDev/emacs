;;; -*- lexical-binding: t -*-
;; TODO: Make apheleia use deno for svelte
(package! apheleia
  :init
  (apheleia-global-mode +1))



(package! company)

(package! corfu
  :defer 5
  :config
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

(package! devdocs
  ;; devdocs-update-all
  ;; devdocs-install
  :config
  (def!
    :keymaps 'rond/code-map
    "l" #'devdocs-lookup)
  (defun devdocs-ensure (&rest slugs)
    "Ensure that all documents listed in SLUGS are installed."
    (dolist (slug slugs)
      (unless (file-exists-p (expand-file-name (format "devdocs/%s/metadata" slug)
                                               user-emacs-directory)) ;; This assumes you didn't customize `devdocs-data-dir'.
        (devdocs-install slug))))
  (eval-when-compile
    (apply #'devdocs-ensure '(astro bun c cpp css elisp git go haxe html http nix php rust sass vite zig zsh))))



(package! direnv
  :defer 10
  :config
  (direnv-mode))

;; dumb-jump is jump to definition for 50+ languages
(package! dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(package! elisp-mode
  :ensure nil
  :config
  (general-spc
    :major-modes '(emacs-lisp-mode lisp-interaction-mode t)
    :keymaps     '(emacs-lisp-mode-map lisp-interaction-mode-map)
    "e"  '(:ignore t :which-key "eval")
    "eb" 'eval-buffer
    "ed" 'eval-defun
    "ee" 'eval-expression
    "ep" 'pp-eval-last-sexp
    "es" 'eval-last-sexp
    "i"  'elisp-index-search))

(package! hyprlang-ts-mode)

(package! nix-mode)

(package! qml-mode)

(package! tempel ;; templates
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert)
         ("S-C-y" . tempel-insert)))

(package! tempel-collection
  :after 'tempel)

(package! treesit-auto
  :config
  (global-treesit-auto-mode))

;; (package! treesit-fold
;;   :config
;;   (global-treesit-fold-mode))

(package! tree-sitter-langs
  :defer t)

;; (package! vimish-fold)

(package! yasnippet
  :commands (yas-global-mode)
  :config
  (def!
    :states '(insert)
    "C-S-i" #'yas-insert-snippet)
  (general-spc
    "is" #'yas-insert-snippet))

(package! yasnippet-snippets
  :after (yasnippet))
(package! auto-yasnippet
  :after (yasnippet))

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/lang/*/*.el")))
(load (expand-file-name "modules/lang/config.el" user-emacs-directory))
