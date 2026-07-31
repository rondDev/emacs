;;; -*- lexical-binding: t -*-
;; Display searches like anzu.vim
(package! anzu
  :defer 10)

(package! colorful-mode
  ;; :diminish
  ;; :ensure t ; Optional
  :hook (prog-mode text-mode)
  :defer 5)

(package! consult-todo
  :after consult) ; https://github.com/eki3z/consult-todo

(package! doom-themes
  :defer t)

(package! doom-modeline
  :defer t
  :init
  (add-hook 'emacs-startup-hook #'doom-modeline-mode))

(elpaca (doom-snippets
          :host github
          :repo "doomemacs/snippets"))

(package! eldoc
  :custom (eldoc-idle-delay 0)
  :ensure nil)


;; (package! eldoc-box
;;   :after eldoc)

(package! evil-search-highlight-persist
  :after evil)

(package! flymake-popon
  :hook (flymake-mode . flymake-popon-mode))

(package! git-gutter
  :config
  (setq git-gutter:update-interval 2
    git-gutter:added-sign " + "
    git-gutter:modified-sign " * "
    git-gutter:deleted-sign " - ")
  :hook (prog-mode . git-gutter-mode))

(package! indent-bars
  :hook (prog-mode . indent-bars-mode))

(package! ligature)

(package! magit-todos
  :after magit)

;; Enable rich annotations using the Marginalia package
(package! marginalia
  :defer 2
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
          ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(package! nerd-icons
  :demand t)

(package! nerd-icons-completion
  :after marginalia)

(package! nerd-icons-corfu
  :after corfu
  :init
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter

    ;; Optionally:
    (setq nerd-icons-corfu-mapping
      '((array :style "cod" :icon "symbol_array" :face font-lock-type-face
          (boolean :style "cod" :icon "symbol_boolean" :face font-lock-builtin-face)
          ;; ...
          (t :style "cod" :icon "code" :face font-lock-warning-face))))))

(package! nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(package! nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(package! page-break-lines
  :hook (emacs-startup . global-page-break-lines-mode))

(package! pulsar
  :hook (elpaca-after-init . pulsar-global-mode))

(package! rainbow-delimiters)

(package! simple
  :ensure nil)

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

;; (package! treesit-fold-indicators
;;   :ensure (treesit-fold-indicators :host github :repo "emacs-tree-sitter/treesit-fold")
;;   :config
;;   (global-treesit-fold-indicators-mode))

(package! unicode-fonts
  :defer 8
  :init
  (add-hook 'emacs-startup-hook #'unicode-fonts-setup))

(package! window
  :ensure nil)

(package! which-key
  :demand t
  :init
  (setq which-key-enable-extended-define-key t))
