(after! general
  (general-evil-setup)
  (general-auto-unbind-keys)
  (defalias 'def! 'general-def)

  (general-create-definer general-spc
    :states '(normal visual)
    :keymaps 'override
    :prefix "SPC")

  (general-create-definer general-cc
    :states '(normal insert)
    ;; don’t want prefix in e.g. vterm insert
    ;; :keymaps 'override
    :prefix "C-c")

  (general-create-definer general-t
    :states 'normal
    :keymaps 'override
    :prefix "t")

  (general-create-definer general-r
    :states 'motion
    :prefix "r")

  ;; TODO rename to something else
  (general-create-definer general-s
    :keymaps '(insert normal)
    :keymaps 'override
    :prefix "C-t")

  (general-create-definer general-m
    :states 'normal
    :prefix "m")

  (general-create-definer local-def!
    :states '(normal visual motion)
    :prefix ",")

  (def!
    :states '(normal visual motion)
    "gcc" #'evilnc-comment-or-uncomment-lines
    "L" #'evil-end-of-line
    "H" #'evil-first-non-blank
    "C-i" #'evil-jump-forward)

  (def!
    :states '(visual motion)
    "gc" #'evilnc-comment-or-uncomment-lines)


  ;; (after! eldoc
  ;;   (def!
  ;;     :keymaps 'override
  ;;     :states '(normal motion)
  ;;     "K" 'eldoc-box-help-at-point))
 (def!
       :package 'corfu
       :keymaps '(override corfu-map)
       "C-y" #'corfu-complete)

 (def!
   :keymaps '(magit-mode-map magit-status-mode)
   "h" 'evil-backward-char
   "j" 'evil-next-visual-line
   "k" 'evil-previous-line
   "l" 'evil-forward-char)
  ;; (magit-diff-visit-worktree-file &optional OTHER-WINDOW)
  ;; (magit-diff-visit-file &optional OTHER-WINDOW)


  
 (defalias 'var! 'defvar)
  
 (var! rond/buffer-map (make-sparse-keymap) "Custom keymap for buffers")
 (var! rond/file-map (make-sparse-keymap) "Custom keymap for file stuff")
 (var! rond/helpful-map (make-sparse-keymap) "Custom keymap for helpful")
 (var! rond/lsp-map (make-sparse-keymap) "Custom keymap for all things lsp")
 (var! rond/projectile-map (make-sparse-keymap) "Custom keymap for projectile")
 (var! rond/update-map (make-sparse-keymap) "Custom keymap for changing/updating stuff")

 (general-spc
   "SPC" #'projectile-find-file
   "b" '(:keymap rond/buffer-map :wk "buffer")
   "f" '(:keymap rond/file-map :wk "file")
   "gg" '(magit-status :wk "magit")
   "h" '(:keymap rond/helpful-map :wk "helpful")
   "oo" #'dired-jump
   "p" '(:keymap rond/projectile-map :wk "projectile")
   "sg" #'consult-ripgrep
   "u" '(:keymap rond/update-map :wk "update/change")
   "w" '(:keymap evil-window-map :wk "window")
   "/" #'multi-vterm-dedicated-toggle) 

 (def!
   :states '(normal)
   "N" #'dired-create-empty-file)


 (local-def!
   :keymaps 'dired-mode-map
   "n" #'dired-create-empty-file)

 (local-def!
   :keymaps 'org-mode-map
   "t" #'org-todo)

 (def!
   :keymaps 'rond/buffer-map
   "b" #'switch-to-buffer
   "i" #'ibuffer)

 (def!
   :keymaps 'rond/file-map
   "s" #'save-buffer)

 (def!
   :keymaps 'rond/helpful-map
   "c" #'helpful-command
   "f" #'helpful-function
   "k" #'helpful-key
   "m" #'describe-mode
   "p" #'helpful-at-point
   ;; Easy to remember since you start macro with q
   "q" #'helpful-macro
   "v" #'helpful-variable)

 (local-def!
   :states '(normal visual motion)
   "l" '(:keymap rond/lsp-map :wk "lsp"))

 (def!
   :package 'avy
   :keymaps '(normal visual motion)
   "s" #'avy-goto-char)

 (def!
   :package 'vertico
   :keymaps 'vertico-map
   "C-h" #'vertico-previous-group
   "C-l" #'vertico-next-group)

 (def!
   :keymaps 'rond/projectile-map
   "a" #'projectile-add-known-project
   "b" #'projectile-switch-to-buffer
   "i" #'projectile-ibuffer
   "p" #'projectile-switch-project)



 (def!
   :keymaps 'override))

