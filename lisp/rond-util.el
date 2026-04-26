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

;;;###autoload
(defalias 'var! 'defvar)

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

(defun rond//todo-pattern (keyword color)
  (list (concat "\\(\\s-*\\(" keyword "\\)\\(\s\\|:\\)\\)")
        (list 1 (list :background color :foreground (face-attribute 'default :background) :weight 'bold) t)
        (list 3 (list :background color :foreground color :weight 'bold) t)))

;; TODO: Make this into a macro
;; NOTE: Colors could be updated
;;;###autoload
(defun rond//todo-update-patterns ()
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
          (list (rond//todo-pattern "TODO" todo) 
                (rond//todo-pattern "FIXME" fixme)
                (rond//todo-pattern "REVIEW" review)
                (rond//todo-pattern "HACK" hack)
                (rond//todo-pattern "DEPRECATED" deprecated)
                (rond//todo-pattern "NOTE" note)
                (rond//todo-pattern "BUG" bug)
                (rond//todo-pattern "WARNING" warning)))))

(add-hook 'elpaca-after-init-hook #'rond//todo-update-patterns)

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
                     (face  (nth 1 highlighter))
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
  (rond//todo-update-patterns)
  (dolist (buf (buffer-list))
    (when (buffer-local-value 'rond/todo-mode buf)
      (with-current-buffer buf
        (rond/todo-remove-overlays (point-min) (point-max))
        (jit-lock-refontify)))))

(defgroup rond nil
  "personal config group"
  :group 'convenience
  :prefix "rond/")

(define-minor-mode rond/todo-mode
  "Highlight TODO-style comment keywords."
  :lighter "rond/todo-hl"
  (if rond/todo-mode
      (rond/todo-enable)
    (rond/todo-disable)))

(defun rond//todo-global-mode-turn-on ()
  (rond/todo-mode 1))


(define-globalized-minor-mode rond/todo-global-mode
  rond/todo-mode
  rond//todo-global-mode-turn-on
  :group 'rond)

(rond/todo-global-mode 1)
(advice-add 'load-theme :after #'rond/todo-reload-overlays)
(advice-add 'enable-theme :after #'rond/todo-reload-overlays)


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

;;;###autoload
(defun rond/dired-create-files-bulk (files)
  "Create multiple files at once. Type names separated by spaces."
  (interactive "sFiles to create: ")
  (let ((file-list (split-string files " " t)))
    (dolist (file file-list)
      (write-region "" nil (expand-file-name file dired-directory)))
    (revert-buffer)))

(after! dired
        (general-spc :keymaps 'dired-mode-map
          "n" #'rond/dired-create-files-bulk))

(after! evil
        (advice-add 'evil-force-normal-state :after '(lambda () (evil-ex-execute "noh"))))


(provide 'rond/util)
