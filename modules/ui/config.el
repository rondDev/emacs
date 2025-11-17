(after! doom-modeline
        (doom-modeline-mode 1))

(after! dashboard
        (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
        (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
        (dashboard-setup-startup-hook)
        (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name))))

(after! rainbow-mode
        (add-hook 'emacs-lisp-mode #'rainbow-mode)
        (add-hook 'text-mode #'rainbow-mode)
        (add-hook 'lisp-mode #'rainbow-mode))



(after! hl-todo
        (add-hook 'prog-mode-hook #'hl-todo-mode)
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        '(;; For reminders to change or add something at a later date.
          ("TODO" warning bold)
          ;; For code (or code paths) that are broken, unimplemented, or slow,
          ;; and may become bigger problems later.
          ("FIXME" error bold)
          ;; For code that needs to be revisited later, either to upstream it,
          ;; improve it, or address non-critical issues.
          ("REVIEW" font-lock-keyword-face bold)
          ;; For code smells where questionable practices are used
          ;; intentionally, and/or is likely to break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For sections of code that just gotta go, and will be gone soon.
          ;; Specifically, this means the code is deprecated, not necessarily
          ;; the feature it enables.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; Extra keywords commonly found in the wild, whose meaning may vary
          ;; from project to project.
          ("NOTE" success bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold))))

(after! magit
        (magit-todos-mode 1))

(after! flycheck-hl-todo
        (flycheck-hl-todo-setup))

(after! eldoc-box
        (s-map!
         :states 'motion
         "K" 'eldoc-box-help-at-point))
