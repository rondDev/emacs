;;; config.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2025  

;; Author:  <rond@oizys>
;; Keywords: 

;;;###autoload
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

;;;###autoload
(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(after! apheleia
        ;; NOTE: THERE HAS TO BE A BETTER WAY TO DO THIS
        (after! svelte-mode
                ;; (setf apheleia-formatters
                ;;       (assq-delete-all 'prettier-typescript apheleia-formatters))
                (push '(denofmt-svelte . ("deno" "fmt" "--unstable-component" "--ext" "svelte" "-"))
                      apheleia-formatters))
        ;; (setf (alist-get 'prettier-typescript apheleia-formatters) '("deno" "fmt" "-"))
        (setf (alist-get 'prettier-typescript apheleia-formatters) '("deno" "fmt" "--unstable-component" "--ext" "svelte" "-")))

(after! corfu
        (setq corfu-auto t
              corfu-auto-delay 0.1
              corfu-auto-trigger "." ;; Custom trigger characters
              corfu-quit-no-match 'separator
              corfu-auto-prefix 2
              corfu-popupinfo-delay '(0.5 . 0.5)
              ;; NOTE: Might re-enable soemtime in the future
              text-mode-ispell-word-completion nil)
        (corfu-popupinfo-mode)

        (keymap-set corfu-map "TAB" nil)
        (keymap-set corfu-map "RET" nil))

(after! direnv
        (direnv-mode))

(after! eglot
        (add-to-list 'eglot-server-programs
                     '(svelte-mode . ("svelteserver" "--stdio"))))

(after! eglot-temple
        (eglot-tempel-mode t))

(after! eldoc
        (setq eldoc-echo-area-prefer-doc-buffer t))

(after! flyover
        (setq flyover-debounce-interval 0.1
              flyover-show-virtual-line nil
              flyover-show-at-eol t))

(after! lsp-mode
        (lsp-register-client
         (make-lsp-client :new-connection (lsp-stdio-connection '("deno" "lsp"))
                          ;; :activation-fn (lsp-activate-on "svelte")
                          :major-modes '(typescript-mode js-mode web-mode svelte-mode)
                          :initialized-fn (progn
                                            (after! general
                                                    (comma-def!
                                                      "da" #'rond/deno-add)))

                          ;; :add-on? t  ; This is the crucial flag
                          :server-id 'deno-ls))
        (lsp-register-client
         (make-lsp-client :new-connection (lsp-stdio-connection '("deno" "lsp"))
                          :activation-fn (lsp-activate-on "svelte")
                          :initialized-fn (progn
                                            (after! general
                                                    (comma-def!
                                                      "da" #'rond/deno-add)))

                          :add-on? t  ; This is the crucial flag
                          :server-id 'deno-ls-for-svelte))
        ;; (setq lsp-disabled-clients '((typescript-mode . ts-ls)))
        (add-to-list 'warning-suppress-log-types '(lsp-mode))
        (add-to-list 'warning-suppress-types '(lsp-mode))
        (setq lsp-signature-auto-activate t
              lsp-eldoc-render-all t))

(after! parinfer-rust-mode
        (setq parinfer-rust-check-before-enable nil
              parinfer-rust-preferred-mode "smart"))

(after! tempel
        (setq tempel-path (expand-file-name "templates" user-emacs-directory))
        ;; Setup completion at point
        (defun tempel-setup-capf ()
          ;; Add the Tempel Capf to `completion-at-point-functions'.  `tempel-expand'
          ;; only triggers on exact matches. We add `tempel-expand' *before* the main
          ;; programming mode Capf, such that it will be tried first.
          (setq-local completion-at-point-functions
                      (cons #'tempel-expand completion-at-point-functions)))

        ;; Alternatively use `tempel-complete' if you want to see all matches.  Use
        ;; a trigger prefix character in order to prevent Tempel from triggering
        ;; unexpectly.
        ;; (setq-local corfu-auto-trigger "/"
        ;;             completion-at-point-functions
        ;;             (cons (cape-capf-trigger #'tempel-complete ?/)
        ;;                   completion-at-point-functions))


        (add-hook 'conf-mode-hook 'tempel-setup-capf)
        (add-hook 'prog-mode-hook 'tempel-setup-capf)
        (add-hook 'text-mode-hook 'tempel-setup-capf))
