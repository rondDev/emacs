;; -*- lexical-binding: t; -*-

(package! xref-project-history
  :ensure (:type git
           :repo "https://codeberg.org/imarko/xref-project-history.git"
           :branch "master")
  :custom
  (xref-history-storage #'xref-project-history))

;; (package! tabspaces
;;   ;; use this next line only if you also use straight, otherwise ignore it.
;;   :ensure (:type git :repo "https://codeberg.org/mclear-tools/tabspaces" :branch "main")
;;   :hook (after-init . tabspaces-mode) ;; use this only if you want the minor-mode loaded at startup.
;;   :commands (tabspaces-switch-or-create-workspace
;;              tabspaces-open-or-create-project-and-workspace)
;;   :custom
;;   (tabspaces-use-filtered-buffers-as-default t)
;;   (tabspaces-default-tab "Default")
;;   (tabspaces-remove-to-default t)
;;   (tabspaces-include-buffers '("*scratch*"))
;;   (tabspaces-initialize-project-with-todo t)
;;   (tabspaces-todo-file-name "project-todo.org")
;;   ;; sessions
;;   (tabspaces-session t)
;;   (tabspaces-session-auto-restore t)
;;   ;; additional options
;;   (tabspaces-fully-resolve-paths t)  ; Resolve relative project paths to absolute
;;   (tabspaces-exclude-buffers '("*Messages*" "*Compile-Log*"))  ; Additional buffers to exclude
;;   (tab-bar-new-tab-choice "*scratch*"))

;; ;; Optional: treat plain directories containing a .project file as
;; ;; projects, so they work with tabspaces without version control.
;; ;; See the "Non-VC Projects" section below.
;; ;; (setq project-vc-extra-root-markers '(".project"))

(package! workroom)
