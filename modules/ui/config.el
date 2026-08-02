;; -*- lexical-binding: t; -*-

;; Font fallback

;; If a character is an icon, use Nerd Fonts first
(set-fontset-font "fontset-default" '(#xe000 . #xf8ff)
                  (font-spec :family "NotoSansM Nerd Font Mono"))

;; If a character is East Asian text, use CJK fonts
(set-fontset-font "fontset-default" 'han
                  (font-spec :family "Noto Sans CJK SC"))

;; Tier 1 Universal Fallback: Check for standard symbols/text first
(set-fontset-font "fontset-default" nil
                  (font-spec :family "DejaVu Sans"))

;; Tier 2 Universal Fallback: If DejaVu fails, look for emojis here
(set-fontset-font "fontset-default" nil
                  (font-spec :family "Noto Color Emoji") nil 'append)


(after! anzu
  (global-anzu-mode +1))

(after! colorful-mode
  (setopt colorful-use-prefix t
    colorful-only-strings 'only-prog)
  ;; (css-fontify-colors nil)
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'helpful-mode))

(after! doom-modeline
  (setq doom-modeline-buffer-encoding 'nondefault
    doom-modeline-modal-icon t
    doom-modeline-icon t
    doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (setq doom-modeline-lsp t))


(add-to-list 'global-mode-string
  '(:eval
     (when (and (bound-and-true-p eglot--managed-mode)
             (eglot-current-server))
       (let ((pending (if (fboundp 'jsonrpc-continuation-count)
                        (jsonrpc-continuation-count (eglot-current-server))
                        (hash-table-count
                          (jsonrpc--request-continuations (eglot-current-server))))))
         (if (> pending 0)
           (format " [ LSP %d⇡ ]  " pending)
           " [ LSP✓ ]   ")))))


(after! eldoc
  ; (add-to-list 'display-buffer-alist
  ;   '("^\\*eldoc" ; Match the buffer name, which changes based on context
  ;      display-buffer-pop-up-window
  ;      (window-height . 6))) ; Optionally set width (as a fraction of frame or specific number of columns))


 (after! eldoc-box
   ;; (add-hook 'eldoc-box-buffer-hook
   ;;          (lambda ()
   ;;            (define-key (current-local-map) (kbd "q") #'eldoc-box-quit-frame)
   ;;            (define-key (current-local-map) (kbd "<escape>") #'eldoc-box-quit-frame)))
  (add-hook 'eldoc-box-buffer-hook
            (lambda ()
              (local-set-key (kbd "q") #'my-safe-eldoc-box-quit)
              (local-set-key (kbd "<escape>") #'my-safe-eldoc-box-quit)))
  (setq eldoc-box-clear-with-C-g t)
  (add-to-list 'eldoc-box-frame-parameters
    '(cursor-type . box)))
   ;; '((no-accept-focus . nil)
     ;; (no-focus-on-map . nil)
     ;; (skip-taskbar . nil)
     ;; (undecorated . nil)))



 (defvar r//eldoc-box-source-frame nil)
 (defun r/eldoc-box-focus ()
   (interactive)
   (when (and (boundp 'eldoc-box--frame) eldoc-box--frame
           (frame-live-p eldoc-box--frame))
     (progn
       (setq r//eldoc-box-source-frame (selected-frame))
       (select-frame-set-input-focus eldoc-box--frame)
       (goto-char (point-min))
       (evil-normal-state))))
 (defun my-safe-eldoc-box-quit ()
  "Safely shift focus back to the parent file buffer before destroying the childframe."
    (interactive)
    (let ((parent-buffer (eldoc-box--current-buffer)))
      ;; 1. Check if we have a valid parent code buffer to jump back to
      (when (buffer-live-p parent-buffer)
        (switch-to-buffer parent-buffer))
      ;; 2. Clear focus mechanics completely
      (setq-local cursor-type nil)
      ;; 3. Safely kill the childframe window now that focus has left it
      (eldoc-box-quit-frame)))
 (defun r/eldoc-box-unfocus ()
   (interactive)
   (when (and r//eldoc-box-source-frame
           (frame-live-p r//eldoc-box-source-frame))
     (select-frame-set-input-focus r//eldoc-box-source-frame)
     (setq r//eldoc-box-source-frame nil)))

 (defun r/eldoc-box-focused-p ()
   (and (boundp 'eldoc-box--frame)
     eldoc-box--frame
     (frame-live-p eldoc-box--frame)
     (eq (selected-frame) eldoc-box--frame)))
 (defun r/eldoc-box-toggle-focus ()
   "Toggle context cleanly between code and the eldoc-box popup."
   (interactive)
   (if (r/eldoc-box-focused-p)
     (r/eldoc-box-unfocus)
     (r/eldoc-box-focus))))

  ;; (advice-add #'keyboard-quit :before #'(lambda ()
  ;;                                         (other-buffer)))


(after! evil-search-highlight-persist
  (global-evil-search-highlight-persist t)
  (evil-ex-define-cmd "noh[ighlight]" 'evil-search-highlight-persist-remove-all))

(after! flymake-popon
  ;; 1. Prevent flymake-popon from automatically showing popups on hover
  (setq flymake-popon-delay nil)

  ;; 2. Create an on-demand popup command
  (defun r/flymake-popon-trigger ()
    "Manually trigger the flymake-popon popup at point."
    (interactive)
    (if (flymake-diagnostics (point))
        (flymake-popon--show-popup)
      (message "No diagnostics at point.")))

  ;; 3. Make sure the popup dismisses cleanly when moving the cursor
  (add-hook 'post-command-hook #'flymake-popon--post-command))

;; 4. Bind capital 'K' within Eglot to fire the diagnostic popup
;; (with-eval-after-load 'eglot
;;   (keymap-set eglot-mode-map "K" #'r/flymake-popon-trigger))


(after! git-gutter)


(after! ligature
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

(after! magit-todos
  (setq magit-todos-ignored-keywords
    '("DONE"))
  (magit-todos-mode 1)) ; https://github.com/alphapapa/magit-todos

(after! marginalia
  (setf (alist-get 'elpaca-info marginalia-command-categories) 'elpaca))

(after! nerd-icons
  (push '("^INSTALL\\.rs$" nerd-icons-devicon "nf-dev-rust" :face nerd-icons-maroon)
    nerd-icons-regexp-icon-alist))

(after! nerd-icons-completion
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(after! page-break-lines
  (add-to-list 'page-break-lines-modes 'text-mode)
  (add-to-list 'page-break-lines-modes 'prog-mode)
  (add-to-list 'page-break-lines-modes 'special-mode))

(after! pulsar
  (setq pulsar-pulse t)
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 10)
  (setq pulsar-face 'pulsar-magenta)
  (setq pulsar-highlight-face 'pulsar-yellow)
  ;; (setq pulsar-pulse-region-functions pulsar-pulse-region-common-functions)
  (add-hook 'minibuffer-setup-hook #'pulsar-pulse-line)
  ;; integration with the `consult' package:
  (add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
  (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry)

                                        ; integration with the built-in `imenu':
  (add-hook 'imenu-after-jump-hook #'pulsar-recenter-top)
  (add-hook 'imenu-after-jump-hook #'pulsar-reveal-entry))

(after! rainbow-delimiters
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(after! simple
  (setopt eval-expression-debug-on-error nil
    fill-column 80)) ;"Wrap at 80 columns."

(after! window
  (setopt switch-to-buffer-obey-display-actions t
    switch-to-prev-buffer-skip-regexp
    '("\\*Help\\*" "\\*Calendar\\*" "\\*mu4e-last-update\\*"
       "\\*Messages\\*" "\\*scratch\\*" "\\magit-.*")))

(after! which-key
  (which-key-mode)
  (setopt which-key-side-window-location 'bottom
    which-key-sort-order 'which-key-key-order-alpha
    which-key-side-window-max-width 0.33
    which-key-idle-delay 0.2))
