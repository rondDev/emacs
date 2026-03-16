;;; -*- lexical-binding: t -*-
;;;###autoload
(defmacro after! (package &rest body)
  `(with-eval-after-load ',package ,@body))

;;;###autoload
(defmacro s-map! (&rest body)
  "Safe mapping for keybinds"
  `(after! general (general-define-key ,@body)))

;;;###autoload
(defalias 'package! 'use-package)

;; Thanks https://blog.meain.io/2020/emacs-highlight-yanked/
(defun rond/evil-yank-advice (orig-fn beg end &rest args)
  (pulse-momentary-highlight-region beg end)
  (apply orig-fn beg end args))

(advice-add 'evil-yank :around 'rond/evil-yank-advice)

;; TODO: test todo
;; FIXME: test todo
;; REVIEW: test todo
;; HACK: test todo
;; DEPRECATED: test todo
;; NOTE: test todo
;; BUG: test todo
;; WARNING: test todo

(defvar rond/todo-patterns nil)

;; TODO: Make this into a macro
;; NOTE: Colors could be updated
;;;###autoload
(defun rond/todo-update-patterns ()
  (let ((bg (face-attribute 'default :background))
        (todo (face-foreground 'warning))
        (fixme (face-foreground 'error))
        (review (face-foreground 'font-lock-keyword-face))
        (hack (face-foreground 'font-lock-constant-face))
        (deprecated (face-foreground 'font-lock-string-face))
        (note (face-foreground 'success))
        (bug (face-foreground 'error))
        (warning (face-foreground 'font-lock-constant-face)))
    (setq rond/todo-patterns
          `(("\\(\\s-*\\(TODO\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,todo :foreground ,bg :weight bold) t)
             (3 '(:background ,todo :foreground ,todo :weight bold) t))
            ("\\(\\s-*\\(FIXME\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,fixme :foreground ,bg :weight bold) t)
             (3 '(:background ,fixme :foreground ,fixme :weight bold) t))
            ("\\(\\s-*\\(REVIEW\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,review :foreground ,bg :weight bold) t)
             (3 '(:background ,review :foreground ,review :weight bold) t))
            ("\\(\\s-*\\(HACK\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,hack :foreground ,bg :weight bold) t)
             (3 '(:background ,hack :foreground ,hack :weight bold) t))
            ("\\(\\s-*\\(DEPRECATED\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,deprecated :foreground ,bg :weight bold) t)
             (3 '(:background ,deprecated :foreground ,deprecated :weight bold) t))
            ("\\(\\s-*\\(NOTE\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,note :foreground ,bg :weight bold) t)
             (3 '(:background ,note :foreground ,note :weight bold) t))
            ("\\(\\s-*\\(BUG\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,bug :foreground ,bg :weight bold) t)
             (3 '(:background ,bug :foreground ,bug :weight bold) t))
            ("\\(\\s-*\\(WARNING\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,warning :foreground ,bg :weight bold) t)
             (3 '(:background ,warning :foreground ,warning :weight bold) t)))))) 

(add-hook 'elpaca-after-init-hook #'rond/todo-update-patterns)

(defun rond/todo-apply-overlays (beg end)
  (rond/todo-remove-overlays beg end)
  (let ((case-fold-search nil))
    (save-excursion
      (dolist (rule rond/todo-patterns)
        (let ((re (car rule)))
          (goto-char beg)
          (while (re-search-forward re end t)
            (dolist (highlighter (cdr rule))
              (let* ((group (nth 0 highlighter))
                     (face  (eval (nth 1 highlighter)))
                     (ov    (make-overlay (match-beginning group)
                                          (match-end group))))
                (overlay-put ov 'face      face)
                (overlay-put ov 'priority  100)
                (overlay-put ov 'evaporate t)
                (overlay-put ov 'rond/todo t)))))))))

(defun rond/todo-remove-overlays (beg end)
  (remove-overlays beg end 'rond/todo t))

(defun rond/todo-enable ()
  (jit-lock-register #'rond/todo-apply-overlays))

(defun rond/todo-disable ()
  (jit-lock-unregister #'rond/todo-apply-overlays)
  (rond/todo-remove-overlays (point-min) (point-max)))

(defun rond/todo-reload-overlays (&rest _)
  (interactive)
  (when rond/todo-global-mode
    (rond/todo-update-patterns)
    (jit-lock-refontify)))

(define-minor-mode rond/todo-mode
  "Highlight TODO-style comment keywords."
  :lighter "rond/todo-hl"
  (if rond/todo-mode
      (rond/todo-enable)
    (rond/todo-disable)))

(define-globalized-minor-mode rond/todo-global-mode
  rond/todo-mode
  (lambda () (rond/todo-mode 1)))

(add-hook 'prog-mode-hook #'rond/todo-global-mode)
(advice-add 'load-theme :after #'rond/todo-reload-overlays)


;;;###autoload
(defun sudo-remote-find-file (file)
  "Opens repote FILE with root privileges."
  (interactive "FFind file: ")
  (setq begin (replace-regexp-in-string  "scp" "ssh" (car (split-string file ":/"))))
  (setq end (car (cdr (split-string file "@"))))
  (set-buffer
   (find-file (format "%s" (concat begin "|sudo:root@" end)))))


;;;###autoload
(defun rond/compile-from-clipboard ()
  "Compile from clipboard"
  (interactive)
  (let ((command-text (car kill-ring)))
    (when command-text
      (setq compile-command command-text)
      (compile compile-command))))

;;;###autoload
(defun spacemacs/rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
         (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let* ((dir (file-name-directory filename))
             (new-name (read-file-name "New name: " dir)))
        (cond ((get-buffer new-name)
               (error "A buffer named '%s' already exists!" new-name))
              (t
               (let ((dir (file-name-directory new-name)))
                 (when (and (not (file-exists-p dir)) (yes-or-no-p (format "Create directory '%s'?" dir)))
                   (make-directory dir t)))
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)
               (when (fboundp 'recentf-add-file)
                 (recentf-add-file new-name)
                 (recentf-remove-if-non-kept filename))
               (message "File '%s' successfully renamed to '%s'" name (file-name-nondirectory new-name))))))))


;; NOTE: Fixes ansi colors in compilation mode
(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))

;;;###autoload
(defun rond/eval-last-sexp ()
  (interactive)
  (let ((result (eval-last-sexp nil)))
    (kill-new (format "%S" result))
    (message "Result copied: %S" result)))

(provide 'rond/util)
