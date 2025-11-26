;;; modules/lang/lsp.el --- Common LSP setup
;;; Commentary:

;; ;;;###autoload
;; (defun lsp-booster--advice-json-parse (old-fn &rest args)
;;   "Try to parse bytecode instead of json."
;;   (or
;;    (when (equal (following-char) ?#)
;;      (let ((bytecode (read (current-buffer))))
;;        (when (byte-code-function-p bytecode)
;;          (funcall bytecode))))
;;    (apply old-fn args)))
;; (advice-add (if (progn (require 'json)
;;                        (fboundp 'json-parse-buffer))
;;                 'json-parse-buffer
;;               'json-read)
;;             :around
;;             #'lsp-booster--advice-json-parse)

;; ;;;###autoload
;; (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
;;   "Prepend emacs-lsp-booster command to lsp CMD."
;;   (let ((orig-result (funcall old-fn cmd test?)))
;;     (if (and (not test?)                             ;; for check lsp-server-present?
;;              (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
;;              lsp-use-plists
;;              (not (functionp 'json-rpc-connection))  ;; native json-rpc
;;              (executable-find "emacs-lsp-booster"))
;;         (progn
;;           (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
;;             (setcar orig-result command-from-exec-path))
;;           (message "Using emacs-lsp-booster for %s!" orig-result)
;;           (cons "emacs-lsp-booster" orig-result))
;;       orig-result)))
;; (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(package! eglot
  :defer 3)

(package! eglot-booster
  :ensure (eglot-booster :host github
                         :repo "https://github.com/jdtsmith/eglot-booster")
  :after eglot
  :defer 3
  :config (eglot-booster-mode))


(package! eglot-tempel
  :disabled t
  :defer 3
  :after eglot)

(package! flycheck-popup-tip
  :defer 10)

(package! flycheck-eglot
  :defer 3
  :after eglot)

(package! flymake
  :defer 10)

(package! flyover
  :disabled t
  :hook (prog-mode))

(package! flycheck-eglot
  :after eglot
  :defer 3
  :ensure nil
  :hook (eglot-managed-mode . flycheck-eglot-mode)
  :custom (flycheck-eglot-exclusive nil))

(package! parinfer-rust-mode
  :hook emacs-lisp-mode)

(package! jsonrpc
  :defer 3)

;; (use-package lsp-mode
;;   :ensure t
;;   :hook ((js-mode . lsp-deferred)
;;          (typescript-mode . lsp-deferred)
;;          (svelte-mode . lsp-deferred)))

;; ;; TODO: Move or refactor this
;; ;;;###autoload
;; (defun rond/deno-add ()
;;   "Run `compile' in the project root with `command'."
;;   (interactive)
;;   (let ((default-directory (project-root (project-current t))))
;;     (let ((r (read-string "Command to run: " "deno add ")))
;;       (compile r))))

;; (use-package lsp-ui
;;   :ensure t
;;   :after lsp-mode
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :custom
;;   ;; Sideline configuration
;;   (lsp-ui-sideline-enable t)
;;   (lsp-ui-sideline-show-diagnostics t)
;;   (lsp-ui-sideline-show-hover t)

;;   ;; (lsp-ui-doc-position 'at-point)
;;   (lsp-ui-doc-enable t)
;;   (lsp-ui-doc-include-signature t)
;;   ;; Flycheck integration
;;   ;; (lsp-ui-flycheck-list-position 'bottom)
;;   :bind
;;   (:map lsp-ui-mode-map
;;         ("C-c C-j" . lsp-ui-peek-find-definitions)
;;         ("C-c i"   . lsp-ui-peek-find-implementation)))



(elpaca
    (lsp-bridge
     :host github
     :repo "manateelazycat/lsp-bridge"
     :branch "master"
     :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
     ;; do not perform byte compilation or native compilation for lsp-bridge
     :build (:not '(elpaca--byte-compile compile)))
  :init
  (setq lsp-bridge-python-command "python3")
  (setq lsp-bridge-user-langserver-dir (expand-file-name "modules/lang/lsp-bridge/langserver" user-emacs-directory))
  (setq lsp-bridge-user-multiserver-dir (expand-file-name "modules/lang/lsp-bridge/multiserver" user-emacs-directory))
  :config
  (global-lsp-bridge-mode)
  (add-hook 'lsp-bridge-mode-hook #'(lambda () (when (functionp 'flymake-mode) (flymake-mode +1))))
  (def!
    :keymaps '(prog-mode-map text-mode-map)
    :states '(insert)
    "C-y" #'acm-complete
    "C-j" #'acm-select-next
    "C-k" #'acm-select-prev)
  (setq lsp-bridge-get-single-lang-server-by-project
        (lambda (project-path file-path)
          (when (or (string-suffix-p ".ts" file-path))
            (string-suffix-p ".tsx" file-path)
            deno)))

  (rassq-delete-all 'svelte-mode lsp-bridge-single-lang-server-mode-list)
  (setq acm-enable-doc t)
  (setq acm-enable-capf t)
  (setq acm-enable-tabby nil)
  (setq acm-enable-tabnine nil)
  (setq acm-enable-codeium nil)
  (setq acm-enable-quick-access t)
  (setq acm-enable-doc-markdown-render t)
  (setq acm-enable-lsp-workspace-symbol t)
  (setq lsp-bridge-enable-org-babel t)
  (setq lsp-bridge-enable-with-tramp t)
  (setq lsp-bridge-semantic-tokens t)
  (setq lsp-bridge-signature-show-function 'lsp-bridge-signature-show-with-frame)
  (setq lsp-bridge-enable-org-babel t)
  (setq lsp-bridge-enable-signature-help t)
  ;; NOTE: Might not be desired
  (setq lsp-bridge-enable-completion-in-minibuffer t)
  (setq lsp-bridge-enable-hover-diagnostic t)
  (setq lsp-bridge-enable-inlay-hint t)
  ;; NOTE: idk how much this affects performance, but i'd like it to update fast
  (setq lsp-bridge-breadcrumb-idle-delay 0.1)
  (setq lsp-bridge-mode-lighter " 🚀")
  (setq lsp-bridge-multi-lang-server-extension-list
        (cl-remove-if (lambda (item)
                        (equal (car item) '("ts" "tsx")))
                      lsp-bridge-multi-lang-server-extension-list))
  ;; (setf (alist-get 'typescript-ts-mode 'lsp-bridge-single-lang-server-mode-list)  "deno")
  (add-to-list 'lsp-bridge-single-lang-server-mode-list '((typescript-ts-mode) . "deno"))
  (add-to-list 'lsp-bridge-single-lang-server-mode-list '((svelte-mode) . "svelteserver"))
  ;; (add-to-list 'lsp-bridge-single-lang-server-mode-list '((emacs-lisp-mode) . "eask"))

  ;; (add-to-list 'lsp-bridge-multi-lang-server-mode-list '((svelte-mode) . "svelte_deno_tailwind"))
  ;; (add-to-list 'lsp-bridge-multi-lang-server-extension-list '(("svelte") . "svelte_deno_tailwind"))
  (add-hook 'lsp-bridge-mode-hook 'flymake-mode)
  (add-hook 'lsp-bridge-mode-hook 'lsp-bridge-breadcrumb-mode))




(package! markdown-mode)
