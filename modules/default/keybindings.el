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

  (general-def 'emacs "<escape>" #'evil-normal-state)

  (def!
    :states '(normal visual motion)
    "gcc" #'evilnc-comment-or-uncomment-lines
    ;; "K" #'lsp-bridge-popup-documentation
    "L" #'evil-end-of-line
    "H" #'evil-first-non-blank
    "M-p" #'flymake-goto-prev-error
    "M-n" #'flymake-goto-next-error)

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




  (var! r/buffer-map (make-sparse-keymap) "Custom keymap for buffers")
  (var! r/code-map (make-sparse-keymap) "Custom keymap for code (LSP)")
  (var! r/file-map (make-sparse-keymap) "Custom keymap for file stuff")
  (var! r/git-map (make-sparse-keymap) "Custom keymap for git thingies")
  (var! r/helpful-map (make-sparse-keymap) "Custom keymap for helpful")
  (var! r/lsp-map (make-sparse-keymap) "Custom keymap for all things lsp")
  (var! r/open-map (make-sparse-keymap) "Custom keymap to open stuff")
  (var! r/project-map (make-sparse-keymap) "Custom keymap for project")
  (var! r/search-map (make-sparse-keymap) "Custom keymap for search")
  (var! r/update-map (make-sparse-keymap) "Custom keymap for changing/updating stuff")

  ;; NOTE: Might want to change capitalization of the which-key labels
  (general-spc
    "SPC" #'project-find-file
    "TAB" #'execute-extended-command
    "b" '(:keymap r/buffer-map :wk "buffer")
    "c" '(:keymap r/code-map :wk "code map")
    "d" #'flymake-show-diagnostic
    "e" '(revert-buffer-quick :wk "revert buffer")
    "f" '(:keymap r/file-map :wk "file")
    "g" '(:keymap r/git-map :wk "git")
    "h" '(:keymap r/helpful-map :wk "helpful")
    "o" '(:keymap r/open-map :wk "open")
    "p" '(:keymap r/project-map :wk "project")
    "s" '(:keymap r/search-map :wk "search")
    "u" '(:keymap r/update-map :wk "update/change")
    "w" '(:keymap evil-window-map :package evil :wk "window")
    "v" #'doom/toggle-scratch-buffer
    "/" #'ghostel-project
    "," #'consult-buffer
    "." #'dired-jump)

  (def!
    :keymaps 'override
    "C-/" #'term-toggle-vterm)

  (def!
    :keymaps 'r/buffer-map
    "b" #'switch-to-buffer
    "k" #'kill-buffer
    "m" (lambda () (interactive) (switch-to-buffer "*Messages*"))
    "s" #'scratch-buffer
    "i" #'ibuffer)

  (def!
    :keymaps 'r/code-map
    "a" #'eglot-code-actions
    "c" #'compile
    "e" #'r/eval-last-sexp
    "d" #'eldoc-doc-buffer
    "r" #'eglot-rename
    "x" #'quickrun
    "X" #'quickrun-shell)

  (def!
    :keymaps 'r/file-map
    "f" #'find-file
    "c" #'r/find-config-file
    "d" #'dired
    "r" #'rename-file
    "s" #'save-buffer)

  (def!
    :keymaps 'r/git-map
    "b" #'magit-blame
    "co" #'magit-checkout
    "cc" #'magit-clone
    "g" '(magit-status :wk "magit")
    "i" '(magit-init :wk "git init")
    "l" #'magit-log-buffer-file
    "s" #'magit-worktree
    "v" #'git-link)

  (def!
    :keymaps 'r/helpful-map
    "c" #'helpful-command
    "f" #'helpful-function
    "k" #'helpful-key
    "m" #'describe-mode
    "p" #'helpful-at-point
    ;; Easy to remember since you start macro with q
    "q" #'helpful-macro
    "v" #'helpful-variable)

  (comma-def!
    "b" '(bookmark-map :wk "Bookmarks")
    "da" #'r/deno-add
    "i" #'consult-imenu
    "I" #'consult-imenu-multi
    "l" '(:keymap r/lsp-map :wk "lsp"))

  (comma-def!
    :keymaps '(rust-ts-mode-map)
    "r" '(:keymap cargo-mode-command-map :package cargo-mode :wk "cargo-mode"))

  (def!
    :keymaps 'r/open-map
    "o" #'dired-jump
    "t" #'vterm-other-window)

  (def!
    :keymaps 'r/search-map
    "g" #'consult-ripgrep
    "b" #'+default/search-buffer
    "p" #'+default/search-project
    "P" #'+default/search-project-for-symbol-at-point)


  (def!
    :keymaps 'r/update-map
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
    :keymaps '(eglot-mode-map override))
    ;; "K" #'eldoc-box-help-at-point)

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

  (def! :keymaps '(minibuffer-local-map)
    :states '(normal visual motion insert)
    "C-;" #'embark-act)


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
    "C-l" #'vertico-next-group
    "C-w" #'evil-window-map)


  (def!
    :keymaps 'r/project-map
    "&" #'project-async-shell-command
    ;; "a" #'project-add-known-project
    "b" #'project-switch-to-buffer
    ;; "D" #'project-discover-projects-in-search-path
    "i" '(lambda () (interactive) (project-list-buffers-ibuffer (project-current)))
    "p" #'project-switch-project
    "x" #'doom/toggle-project-scratch-buffer))
