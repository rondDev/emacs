;;; modules/lang/lsp.el --- Common LSP setup;;; -*- lexical-binding: t -*-
;;; Commentary:

(package! flymake
  :ensure (flymake
           :host github
           :repo "flymake/emacs-flymake"
           :branch "master"))


(package! parinfer-rust-mode
  :hook emacs-lisp-mode)

(package! jsonrpc
  :defer 3)

;; TODO: Move or refactor this
;;;###autoload
(defun rond/deno-add ()
  "Run `compile' in the project root with `command'."
  (interactive)
  (let ((default-directory (project-root (project-current t))))
    (let ((r (read-string "Command to run: " "deno add ")))
      (compile r))))

;; (elpaca
;;     (lsp-bridge
;;      :repo "~/code/lsp-bridge"
;;      ;; :host github
;;      ;; :repo "manateelazycat/lsp-bridge"
;;      ;; :branch "master"
;;      :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
;;      ;; do not perform byte compilation or native compilation for lsp-bridge
;;      :build (:not '(elpaca--byte-compile compile)))
;;   :init
;;   (setq lsp-bridge-python-command "python3")
;;   (setq lsp-bridge-user-langserver-dir (expand-file-name "modules/lang/lsp-bridge/langserver" user-emacs-directory))
;;   (setq lsp-bridge-user-multiserver-dir (expand-file-name "modules/lang/lsp-bridge/multiserver" user-emacs-directory))
;;   :disabled t
;;   :config
;;   (global-lsp-bridge-mode)
;;   (add-hook 'lsp-bridge-mode-hook #'(lambda () (when (functionp 'flymake-mode) (flymake-mode +1))))
;;   (def!
;;     :keymaps '(prog-mode-map text-mode-map)
;;     :states '(insert)
;;     "C-y" #'acm-complete
;;     "C-j" #'acm-select-next
;;     "C-k" #'acm-select-prev)
;;   ;; (setq lsp-bridge-get-single-lang-server-by-project
;;   ;;       (lambda (project-path file-path)
;;   ;;         (when (or (string-suffix-p ".ts" file-path))
;;   ;;           (string-suffix-p ".tsx" file-path)
;;   ;;           deno)))

;;   (rassq-delete-all 'svelte-mode lsp-bridge-single-lang-server-mode-list)
;;   (setq acm-enable-doc t)
;;   (setq acm-enable-capf t)
;;   (setq acm-enable-tabby nil)
;;   (setq acm-enable-tabnine nil)
;;   (setq acm-enable-codeium nil)
;;   (setq acm-enable-quick-access t)
;;   (setq acm-enable-doc-markdown-render t)
;;   (setq acm-enable-lsp-workspace-symbol t)
;;   (setq lsp-bridge-enable-org-babel t)
;;   (setq lsp-bridge-enable-with-tramp t)
;;   (setq lsp-bridge-semantic-tokens t)
;;   (setq lsp-bridge-signature-show-function 'lsp-bridge-signature-show-with-frame)
;;   (setq lsp-bridge-enable-org-babel t)
;;   (setq lsp-bridge-enable-signature-help t)
;;   ;; NOTE: Might not be desired
;;   (setq lsp-bridge-enable-completion-in-minibuffer t)
;;   (setq lsp-bridge-enable-hover-diagnostic t)
;;   (setq lsp-bridge-enable-inlay-hint t)
;;   ;; TODO: Remove after testing
;;   (setq lsp-bridge-enable-log t)
;;   ;; NOTE: idk how much this affects performance, but i'd like it to update fast
;;   (setq lsp-bridge-breadcrumb-idle-delay 0.1)
;;   (setq lsp-bridge-mode-lighter " 🚀")
;;   (setq lsp-bridge-multi-lang-server-extension-list
;;         (cl-remove-if (lambda (item)
;;                         (equal (car item) '("ts" "tsx")))
;;                       lsp-bridge-multi-lang-server-extension-list))

;;   ;; (setf (alist-get 'typescript-ts-mode 'lsp-bridge-single-lang-server-mode-list)  "deno")
;;   (add-to-list 'lsp-bridge-single-lang-server-mode-list '((typescript-ts-mode) . "deno"))
;;   (add-to-list 'lsp-bridge-single-lang-server-mode-list '((svelte-mode) . "svelteserver"))
;;   (add-to-list 'lsp-bridge-single-lang-server-mode-list '((emacs-lisp-mode) . "ellsp"))

;;   ;; (add-to-list 'lsp-bridge-multi-lang-server-mode-list '((svelte-mode) . "svelte_deno_tailwind"))
;;   ;; (add-to-list 'lsp-bridge-multi-lang-server-extension-list '(("svelte") . "svelte_deno_tailwind"))
;;   ;; (add-hook 'lsp-bridge-mode-hook 'flymake-mode)
;;   (add-hook 'lsp-bridge-mode-hook 'lsp-bridge-breadcrumb-mode)
;;   (setq lsp-bridge-get-lang-server-by-project
;;         (lambda (project-path file-path)
;;           (cond
;;            ((or (member project-path clojure-project-list)
;;                 (locate-dominating-file project-path "deps.edn")
;;                 (locate-dominating-file project-path "project.clj")
;;                 (expand-file-name "clojure-lsp.json" lsp-bridge-directory)))

;;            ((or (member project-path javascript-project-list)
;;                 (locate-dominating-file project-path "package.json")
;;                 (expand-file-name "javascript.json" lsp-bridge-directory)))

;;            ((or (member project-path php-project-list)
;;                 (locate-dominating-file project-path "composer.json")
;;                 (expand-file-name "intelephense.json" lsp-bridge-directory)))

;;            ((or (member project-path rust-project-list)
;;                 (locate-dominating-file project-path "Cargo.toml")
;;                 (expand-file-name "rust-analyzer.json" lsp-bridge-directory)))

;;            ((or (member project-path tailwindcss-project-list)
;;                 (lsp-bridge--tailwindcss-project-p project-path)
;;                 (expand-file-name (if IS-MAC
;;                                       "tailwindcss_darwin.json"
;;                                     "tailwindcss.json") lsp-bridge-directory

;;                                     ((or (member project-path vue-project-list
;;                                                  (lsp-bridge--vue-project-p project-path))
;;                                          (expand-file-name (if IS-MAC
;;                                                                "volar_darwin.json")
;;                                                            "volar.json") lsp-bridge-directory)))))))))


(package! markdown-mode)
