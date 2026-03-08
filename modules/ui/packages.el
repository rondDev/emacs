;;; -*- lexical-binding: t -*-
;; Display searches like anzu.vim
(package! anzu
  :defer 10
  :config
  (global-anzu-mode +1))

(package! colorful-mode
  ;; :diminish
  ;; :ensure t ; Optional
  :hook (prog-mode text-mode)
  :defer 5
  :custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  ;; (css-fontify-colors nil)
  :config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))

(package! consult-todo
  :after consult) ; https://github.com/eki3z/consult-todo

(package! doom-themes
  :defer t)

(package! doom-modeline
  :init
  (setq doom-modeline-buffer-encoding 'nondefault
        doom-modeline-modal-icon t
        doom-modeline-icon t)
  :config
  (doom-modeline-mode 1))

(package! eldoc
  :ensure nil
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*eldoc" ; Match the buffer name, which changes based on context
                 display-buffer-at-bottom
                 (window-height . 6)))) ; Optionally set width (as a fraction of frame or specific number of columns)

(package! eldoc-box
  :after eldoc
  :config
  (defvar rond//eldoc-box-source-frame nil)
  (defun rond/eldoc-box-focus ()
    (interactive)
    (when (and (boundp 'eldoc-box--frame) eldoc-box--frame
               (frame-live-p eldoc-box--frame))
      (progn
        (setq rond//eldoc-box-source-frame (selected-frame))
        (select-frame-set-input-focus eldoc-box--frame)
        (goto-char (point-min))
        (evil-normal-state))))

  (defun rond/eldoc-box-unfocus ()
    (interactive)
    (when (and rond//eldoc-box-source-frame
               (frame-live-p rond//eldoc-box-source-frame))
      (select-frame-set-input-focus rond//eldoc-box-source-frame)
      (setq rond//eldoc-box-source-frame nil)))

  (defun rond/eldoc-box-focused-p ()
    (and (boundp 'eldoc-box--frame)
         eldoc-box--frame
         (frame-live-p eldoc-box--frame)
         (eq (selected-frame) eldoc-box--frame))))

(package! evil-search-highlight-persist
  :config
  (global-evil-search-highlight-persist t)
  (evil-ex-define-cmd "noh[ighlight]" 'evil-search-highlight-persist-remove-all))

(package! git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 2
        git-gutter:added-sign " + "
        git-gutter:modified-sign " * "
        git-gutter:deleted-sign " - "))

(use-package indent-bars
  :hook (prog-mode . indent-bars-mode))

(package! ligature
  :config
  (ligature-set-ligatures 'prog-mode
                          '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                            ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                            "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                            "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                            "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                            "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                            "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                            "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                            ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                            "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                            "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                            "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                            "\\\\" "://"))
  (global-ligature-mode t))

(package! magit-todos
  :after magit
  :config
  (setq magit-todos-ignored-keywords
        '("DONE"))
  (magit-todos-mode 1)) ; https://github.com/alphapapa/magit-todos

;; Enable rich annotations using the Marginalia package
(package! marginalia
  :defer 2
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode)
  :config
  (setf (alist-get 'elpaca-info marginalia-command-categories) 'elpaca))

(package! nerd-icons
  :config
  (after! nerd-icons
          (push '("^INSTALL\\.rs$" nerd-icons-devicon "nf-dev-rust" :face nerd-icons-maroon)
                nerd-icons-regexp-icon-alist)))

(package! nerd-icons-completion
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
  :hook (emacs-startup . global-page-break-lines-mode)
  :config
  (add-to-list 'page-break-lines-modes 'text-mode)
  (add-to-list 'page-break-lines-modes 'prog-mode)
  (add-to-list 'page-break-lines-modes 'special-mode))

(package! pulsar
  :hook (after-init)
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

;; (package! rainbow-mode
;;   :hook (emacs-lisp-mode text-mode lisp-mode)
;;   :config
;;   (defun prot/rainbow-mode-in-themes ()
;;     (when-let ((file (buffer-file-name))
;;                ((derived-mode-p 'emacs-lisp-mode))
;;                ((string-match-p "-theme" file)))
;;       (rainbow-mode 1))))


(package! simple
  :ensure nil
  ;; :general
  ;; (+general-global-toggle
  ;;  "f" 'auto-fill-mode)
  :custom
  (eval-expression-debug-on-error nil)
  (fill-column 80 "Wrap at 80 columns."))

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
  :ensure nil
  :custom
  (switch-to-buffer-obey-display-actions t)
  (switch-to-prev-buffer-skip-regexp
   '("\\*Help\\*" "\\*Calendar\\*" "\\*mu4e-last-update\\*"
     "\\*Messages\\*" "\\*scratch\\*" "\\magit-.*")))

(package! which-key
  :demand t
  :init
  (setq which-key-enable-extended-define-key t)
  :config
  (which-key-mode)
  :custom
  (which-key-side-window-location 'bottom)
  (which-key-sort-order 'which-key-key-order-alpha)
  (which-key-side-window-max-width 0.33)
  (which-key-idle-delay 0.2))
