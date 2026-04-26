;;; config.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author:  <rond@oizys>
;; Keywords: 

(after! apheleia
        ;; NOTE: THERE HAS TO BE A BETTER WAY TO DO THIS
        (setf apheleia-formatters
              (assq-delete-all 'prettier-svelte apheleia-formatters))
        (push '(denofmt-svelte . ("deno" "fmt" "--unstable-component" "--ext" "svelte" "-"))
              apheleia-formatters)
        (push '(qml-mode . qmlformat) apheleia-mode-alist)
        (push '(qmlformat . ("qmlformat")) apheleia-formatters)
        ;; (setf (alist-get 'prettier-typescript apheleia-formatters) '("deno" "fmt" "-"))
        (setf (alist-get 'svelte-mode apheleia-mode-alist) 'denofmt-svelte)
        (setf (alist-get 'prettier-svelte apheleia-formatters) '("deno" "fmt" "--unstable-component" "--ext" "svelte" "-")))

(after! cape
        (add-hook 'completion-at-point-functions #'cape-dabbrev
                  (add-hook 'completion-at-point-functions #'cape-file)
                  (add-hook 'completion-at-point-functions #'cape-elisp-block)))

(after! corfu
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

(after! devdocs
        (def!
          :keymaps 'rond/code-map
          "l" #'devdocs-lookup)
        (eval-when-compile
          (defun devdocs-ensure (&rest slugs)
            "Ensure that all documents listed in SLUGS are installed."
            (dolist (slug slugs)
              (unless (file-exists-p (expand-file-name (format "devdocs/%s/metadata" slug)
                                                       user-emacs-directory)) ;; This assumes you didn't customize `devdocs-data-dir'.
                (devdocs-install slug))))
          (apply #'devdocs-ensure '(astro bun c cpp css elisp git go haxe html http nix php rust sass vite zig zsh)))

        (add-hook 'typescript-mode-hook (lambda () (setq-local devdocs-current-docs '("typescript" "javascript" "node"))))
        (add-hook 'typescript-ts-mode-hook (lambda () (setq-local devdocs-current-docs '("typescript" "node" "bun" "deno~2" "javascript" "dom" "vue~3" "html"))))
        (add-hook 'js-mode-hook (lambda () (setq-local devdocs-current-docs '("javascript" "node" "bun" "deno~2"))))
        (add-hook 'vue-mode-hook (lambda () (setq-local devdocs-current-docs '("typescript" "javascript" "node" "bun" "deno~2" "dom" "vue~3" "html"))))
        (add-hook 'rust-mode-hook (lambda () (setq-local devdocs-current-docs '("rust"))))
        (add-hook 'css-mode-hook (lambda () (setq-local devdocs-current-docs '("css")))))


(after! direnv
        (when (executable-find "direnv")
          (direnv-mode)))

(after! dumb-jump
        (setq dumb-jump-prefer-searcher 'rg)
        (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(after! eldoc
        (setq eldoc-echo-area-prefer-doc-buffer t))

(after! elisp-mode
        (general-spc
          :major-modes '(emacs-lisp-mode lisp-interaction-mode t)
          :keymaps     '(emacs-lisp-mode-map lisp-interaction-mode-map)
          "x"  '(:ignore t :which-key "eval")
          "xb" 'eval-buffer
          "xd" 'eval-defun
          "xe" 'eval-expression
          "xp" 'pp-eval-last-sexp
          "xr" 'eval-region
          "xs" 'eval-last-sexp
          "i"  'elisp-index-search))

(after! eglot
        (add-hook 'eglot-managed-mode-hook
                  (lambda ()
                    ;; Show flymake diagnostics first.
                    (setq eldoc-documentation-functions
                          (cons #'flymake-eldoc-function
                                (remove #'flymake-eldoc-function eldoc-documentation-functions)))
                    ;; Show all eldoc feedback.
                    (setq eldoc-documentation-strategy #'eldoc-documentation-compose))))

(after! parinfer-rust-mode
        (setq parinfer-rust-check-before-enable nil
              parinfer-rust-preferred-mode "smart"))

(after! tempel
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

(after! treesit-auto
        (setopt treesit-auto-install 'prompt)
        (treesit-auto-add-to-auto-mode-alist 'all)
        (global-treesit-auto-mode))

(after! yasnippet
        (def!
          :states '(insert)
          "C-S-i" #'yas-insert-snippet)
        (general-spc
          "is" #'yas-insert-snippet)
        (add-hook 'prog-mode-hook #'yas-minor-mode))

;; Code folding
(add-hook 'prog-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook '(lambda () (setq electric-indent-local-mode nil)))
