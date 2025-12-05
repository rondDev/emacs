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

(defvar rond/todo-patterns nil)

;;;###autoload
(defun rond//todo-max-contrast (face &optional ratio &rest args)
  (let ((r (or ratio 4)))
    (ct-contrast-max (face-foreground face) (face-attribute 'default :background) r))) 


;; TODO: test todo
;; FIXME: test todo
;; REVIEW: test todo
;; HACK: test todo
;; DEPRECATED: test todo
;; NOTE: test todo
;; BUG: test todo
;; WARNING: test todo



;; BUG: It's unreadable in most themes when current line is highlighted
;; NOTE: Could this be a macro?
;; NOTE: Colors could be updated
;;;###autoload
(defun rond/todo-update-patterns ()
  (let ((bg-color (face-attribute 'default :background))
        (todo-color (face-foreground 'warning))
        (fixme-color (face-foreground 'error))
        (review-color (face-foreground 'font-lock-keyword-face))
        (hack-color (face-foreground 'font-lock-constant-face))
        (deprecated-color (face-foreground 'font-lock-doc-face))
        (note-color (face-foreground 'success))
        (bug-color (face-foreground 'error))
        (warning-color (face-foreground 'font-lock-constant-face)))
    ;; (todo-color (rond//max-contrast (or term-color-cyan error)))
    ;; (fixme-color (rond//max-contrast 'term-color-red))
    ;; (review-color (rond//max-contrast 'term-color-yellow))
    ;; (hack-color (rond//max-contrast 'font-lock-constant-face))
    ;; (deprecated-color (rond//max-contrast 'font-lock-doc-face))
    ;; (note-color (rond//max-contrast 'success))
    ;; (bug-color (rond//max-contrast 'error))
    ;; (warning-color (rond//max-contrast 'font-lock-constant-face)))
    (setq rond/todo-patterns 
          `(("\\(\\s-*\\(TODO\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,todo-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,todo-color :foreground ,todo-color :weight bold) t))
            ("\\(\\s-*\\(FIXME\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,fixme-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,fixme-color :foreground ,fixme-color :weight bold) t))
            ("\\(\\s-*\\(REVIEW\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,review-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,review-color :foreground ,review-color :weight bold) t))
            ("\\(\\s-*\\(HACK\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,hack-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,hack-color :foreground ,hack-color :weight bold) t))
            ("\\(\\s-*\\(DEPRECATED\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,deprecated-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,deprecated-color :foreground ,deprecated-color :weight bold) t))
            ("\\(\\s-*\\(NOTE\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,note-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,note-color :foreground ,note-color :weight bold) t))
            ("\\(\\s-*\\(BUG\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,bug-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,bug-color :foreground ,bug-color :weight bold) t))
            ("\\(\\s-*\\(WARNING\\)\\(\s\\|:\\)\\)" 
             (1 '(:background ,warning-color :foreground ,bg-color :weight bold) t)
             (3 '(:background ,warning-color :foreground ,warning-color :weight bold) t))))))

;;;###autoload
(defun rond/todo-update-highlights (&rest args)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when rond/todo-outline-mode
        (font-lock-remove-keywords nil rond/todo-patterns)
        (rond/todo-update-patterns)
        (font-lock-add-keywords nil rond/todo-patterns)
        (font-lock-flush)))))

;; Initialize patterns
(defun rond/todo-initialize ()
  ;; Needed for maxing contrast
  (package! ct)

  (rond/todo-update-patterns))



(define-minor-mode rond/todo-outline-mode
  "Highlight TODOs with theme background for colon."
  :global nil
  (if rond/todo-outline-mode
      (font-lock-add-keywords nil rond/todo-patterns)
    (font-lock-remove-keywords nil rond/todo-patterns))
  (when font-lock-mode (font-lock-flush)))

(add-hook 'prog-mode-hook #'rond/todo-outline-mode)
(advice-add 'enable-theme :after #'rond/todo-update-highlights)


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
