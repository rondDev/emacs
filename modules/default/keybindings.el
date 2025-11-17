(after! general
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

        (general-create-definer general-comma
                                :states 'normal
                                :prefix ",")

        (general-define-key
          :states '(normal visual motion)
          "gcc" #'evilnc-comment-or-uncomment-lines
          "L" #'evil-end-of-line
          "H" #'evil-first-non-blank)
        (general-define-key
         :states '(visual motion)
         "gc" #'evilnc-comment-or-uncomment-lines)

        (after! eldoc
         (general-define-key
          :keymaps 'override
          :states '(normal motion)
          "K" 'eldoc-box-help-at-point))

        (general-define-key
          :states '(visual motion normal)
          :keymaps 'magit-mode-map
          "h" 'evil-backward-char
          "j" 'evil-next-visual-line
          "k" 'evil-previous-line
          "l" 'evil-forward-char)
         
        
        (defvar rond/buffer-map (make-sparse-keymap) "Custom keymap for buffers")
        (defvar rond/file-map (make-sparse-keymap) "Custom keymap for file stuff")
        (defvar rond/helpful-map (make-sparse-keymap) "Custom keymap for helpful")
        (defvar rond/lsp-map (make-sparse-keymap) "Custom keymap for all things lsp")
        (defvar rond/projectile-map (make-sparse-keymap) "Custom keymap for projectile")
        (defvar rond/update-map (make-sparse-keymap) "Custom keymap for changing/updating stuff")

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

        (general-define-key
         :states '(normal)
         "N" #'dired-create-empty-file)


        (general-comma
          :keymaps 'dired-mode-map
          "n" #'dired-create-empty-file)

        (general-comma
          :keymaps 'org-mode-map
          "t" #'org-todo)

        (general-define-key
         :keymaps 'rond/buffer-map
         "b" #'switch-to-buffer
         "i" #'ibuffer)

        (general-define-key 
          :keymaps 'rond/file-map
          "s" #'save-buffer)

        (general-define-key 
          :keymaps 'rond/helpful-map
          "c" #'helpful-command
          "f" #'helpful-function
          "k" #'helpful-key
          "m" #'describe-mode
          "p" #'helpful-at-point
          ;; Easy to remember since you start macro with q
          "q" #'helpful-macro
          "v" #'helpful-variable)

        (general-comma
          "l" '(:keymap rond/lsp-map :wk "lsp"))

        (general-define-key 
          :keymaps 'rond/projectile-map
          "a" #'projectile-add-known-project
          "b" #'projectile-switch-to-buffer
          "i" #'projectile-ibuffer
          "p" #'projectile-switch-project)

        (general-define-key)


        (general-define-key
         :keymaps 'override))
        
