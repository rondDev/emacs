;;; -*- lexical-binding: t -*-
(after! general
        (general-evil-setup)
        (general-auto-unbind-keys)
        (defalias 'def! 'general-def)

        (general-create-definer general-spc
          :states '(normal visual)
          :keymaps 'override
          :prefix "SPC")

        ;; (general-create-definer general-cc
        ;;   :states '(normal insert)
        ;; ;; don’t want prefix in e.g. vterm insert
        ;; ;; :keymaps 'override
        ;; :prefix "C-c")

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

        (general-create-definer comma-def!
          :states '(normal visual motion)
          :prefix ",")

        (def!
          :states '(normal visual motion)
          "gcc" #'evilnc-comment-or-uncomment-lines
          ;; "K" #'lsp-bridge-popup-documentation
          "L" #'evil-end-of-line
          "H" #'evil-first-non-blank)

        (def!
          :states '(visual motion)
          "gc" #'evilnc-comment-or-uncomment-lines)

        (def!
          :states '(insert override)
          "C-S-v" #'yank)


        ;; (after! eldoc
        ;;   (def!
        ;;     :keymaps 'override
        ;;     :states '(normal motion)
        ;;     "K" 'eldoc-box-help-at-point))
        (def!
          :package 'corfu
          :states 'insert
          :keymaps '(corfu-map)
          "C-y" #'corfu-complete)

        ;; (def!
        ;;   :package 'company
        ;;   :keymaps '(override company-map)
        ;;   "C-y" #'company-complete)

        ;; (magit-diff-visit-worktree-file &optional OTHER-WINDOW)
        ;; (magit-diff-visit-file &optional OTHER-WINDOW)


        
        (defalias 'var! 'defvar)
        
        (var! rond/buffer-map (make-sparse-keymap) "Custom keymap for buffers")
        (var! rond/code-map (make-sparse-keymap) "Custom keymap for code (LSP)")
        (var! rond/file-map (make-sparse-keymap) "Custom keymap for file stuff")
        (var! rond/helpful-map (make-sparse-keymap) "Custom keymap for helpful")
        (var! rond/lsp-map (make-sparse-keymap) "Custom keymap for all things lsp")
        (var! rond/open-map (make-sparse-keymap) "Custom keymap to open stuff")
        (var! rond/projectile-map (make-sparse-keymap) "Custom keymap for projectile")
        (var! rond/update-map (make-sparse-keymap) "Custom keymap for changing/updating stuff")

        ;; NOTE: Might want to change capitalization of the which-key labels
        (general-spc
          "SPC" #'projectile-find-file
          "TAB" #'execute-extended-command
          "b" '(:keymap rond/buffer-map :wk "buffer")
          "c" '(:keymap rond/code-map :wk "code map")
          "d" #'flymake-show-diagnostic
          "e" '(revert-buffer-quick :wk "revert buffer")
          "f" '(:keymap rond/file-map :wk "file")
          "g" '(:ignore t :wk "git")
          "gg" '(magit-status :wk "magit")
          "gb" #'magit-blame
          "gl" #'magit-log-buffer-file
          "h" '(:keymap rond/helpful-map :wk "helpful")
          "o" '(:keymap rond/open-map :wk "open")
          "p" '(:keymap rond/projectile-map :wk "projectile")
          "sg" #'consult-ripgrep
          "u" '(:keymap rond/update-map :wk "update/change")
          "w" '(:keymap evil-window-map :package evil :wk "window")
          "/" #'projectile-run-vterm
          "," #'consult-buffer)

        (def!
          :keymaps 'rond/buffer-map
          "b" #'switch-to-buffer
          "k" #'kill-buffer
          "s" #'scratch-buffer
          "i" #'ibuffer)

        (def!
          :keymaps 'rond/code-map
          "a" #'eglot-code-actions
          "c" #'compile
          "e" #'rond/eval-last-sexp
          "d" #'eldoc-doc-buffer
          "r" #'eglot-rename)

        (def!
          :keymaps 'rond/file-map
          "f" #'find-file
          "d" #'dired
          "r" #'rename-file
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

        (comma-def!
          "da" #'rond/deno-add
          "l" '(:keymap rond/lsp-map :wk "lsp"))

        (comma-def!
          :keymaps '(rust-ts-mode-map)
          "r" '(:keymap cargo-mode-command-map :package cargo-mode :wk "cargo-mode"))

        (def!
          :keymaps 'rond/open-map
          "o" #'dired-jump
          "t" #'vterm-other-window)



        (def!
          :keymaps 'rond/update-map
          "t" #'consult-theme)

        (def!
          :states '(normal)
          "N" #'dired-create-empty-file)


        (comma-def!
          :keymaps 'dired-mode-map
          "n" #'dired-create-empty-file)

        (comma-def!
          :keymaps 'org-mode-map
          "i" #'org-indent-mode
          "r" '(font-lock-mode :wk "view raw")
          "t" #'org-todo)

        (def!
          :package 'avy
          :keymaps '(normal visual motion)
          "s" #'avy-goto-char)

        (def!
          :states '(normal visual motion)
          :package 'eglot
          :keymaps '(eglot-mode-map override)
          "K" #'eldoc-box-help-at-point)

        (general-spc
          :package 'eglot
          :keymaps 'eglot-mode-map
          "d" #'flymake-diagnostics)

        (def!
          :package 'org
          :keymaps '(org-mode-map)
          :states '(normal)
          "RET" #'org-goto)

        (def!
          :package 'lsp-bridge
          :keymaps '(acm-mode-map)
          "RET" nil)


        ;; HACK: this has to be set explicitly even when
        ;;       `evil-collection-magit-use-z-for-folds' is set.
        (def!
          :keymaps '(magit-status-mode override)
          :states '(normal visual motion)
          "zm" #'evil-close-folds
          "zr" #'evil-open-folds
          "zz" #'evil-scroll-line-to-center)

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
