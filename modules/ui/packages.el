;; Display searches like anzu.vim
(package! anzu
  :config
  (global-anzu-mode +1))

(package! consult-todo
  :after consult) ; https://github.com/eki3z/consult-todo

(package! dashboard
  :config
 (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
 (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
 (dashboard-setup-startup-hook)
 (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name))))

(package! doom-modeline
  :config
  (doom-modeline-mode 1))

(package! eldoc-box)

;; (package! flycheck-hl-todo
;;   :config
;;   (flycheck-hl-todo-setup)) ; https://github.com/alvarogonzalezsotillo/flycheck-hl-todo

(package! hl-todo
  :init
 (add-hook 'emacs-startup-hook #'global-hl-todo-mode)
 :config
 (setq hl-todo-highlight-punctuation ":"
   hl-todo-keyword-faces
   '(;; For reminders to change or add something at a later date.
     ("TODO" warning bold
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
       ("XXX" font-lock-constant-face bold)))))
  
                                          ; https://github.com/tarsius/hl-todo

(package! magit-todos
  :after magit
  :config
  (setq magit-todos-ignored-keywords
   '("DONE"))
  (magit-todos-mode 1)) ; https://github.com/alphapapa/magit-todos

;; Enable rich annotations using the Marginalia package
(package! marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
          ("M-A" . marginalia-cycle))
  :hook (emacs-startup . marginalia-mode)
  :init)
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  

(package! nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(package! nerd-icons-corfu
  :after corfu
  :init
 (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter

  ;; Optionally:
  (setq nerd-icons-corfu-mapping
        '((array :style "cod" :icon "symbol_array" :face font-lock-type-face)
          (boolean :style "cod" :icon "symbol_boolean" :face font-lock-builtin-face)
          ;; ...
          (t :style "cod" :icon "code" :face font-lock-warning-face)))))

(package! nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(package! nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(package! page-break-lines
  :init
  (add-hook 'emacs-startup-hook #'page-break-lines-mode))

(package! pulsar
  :defer 6
  :config
 (setq pulsar-pulse t)
 (setq pulsar-delay 0.055)
 (setq pulsar-iterations 10)
 (setq pulsar-face 'pulsar-magenta)
 (setq pulsar-highlight-face 'pulsar-yellow)
 (add-hook 'minibuffer-setup-hook #'pulsar-pulse-line)
 ;; integration with the `consult' package:
 (add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
 (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry)

 ;; integration with the built-in `imenu':
 (add-hook 'imenu-after-jump-hook #'pulsar-recenter-top)
 (add-hook 'imenu-after-jump-hook #'pulsar-reveal-entry)
 (pulsar-global-mode 1))

(package! rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(package! rainbow-mode
  :hook (emacs-lisp-mode text-mode lisp-mode)
  :config
  (defun prot/rainbow-mode-in-themes ()
   (when-let ((file (buffer-file-name))
              ((derived-mode-p 'emacs-lisp-mode))
              ((string-match-p "-theme" file)))
     (rainbow-mode 1))))
   


(package! spacious-padding
  :ensure t
  :if (display-graphic-p)
  :hook (elpaca-after-init . spacious-padding-mode)
  :bind ("<f8>" . spacious-padding-mode)
  :init
  ;; These are the defaults, but I keep it here for visiibility.
  (setq spacious-padding-widths
        '( :internal-border-width 30
           :header-line-width 4
           :mode-line-width 6
           :tab-width 4
           :right-divider-width 30
           :scroll-bar-width 8
           :left-fringe-width 20
           :right-fringe-width 20))

  ;; (setq spacious-padding-subtle-mode-line
  ;;       `( :mode-line-active ,(if (or (eq prot-emacs-load-theme-family 'modus)
  ;;                                     (eq prot-emacs-load-theme-family 'standard))
  ;;                                 'default
  ;;                               'help-key-binding)
  ;;          :mode-line-inactive window-divider))

  ;; Read the doc string of `spacious-padding-subtle-mode-line' as
  ;; it is very flexible.
  (setq spacious-padding-subtle-mode-line '(:mode-line-active "#37f499" :mode-line-inactive shadow)))

(package! which-key
  :config
  (setq which-key-idle-delay 0.2)
  (add-hook 'emacs-startup-hook #'which-key-mode))
