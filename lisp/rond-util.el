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
(defun r/evil-yank-advice (orig-fn beg end &rest args)
  (pulse-momentary-highlight-region beg end)
  (apply orig-fn beg end args))

(advice-add 'evil-yank :around 'r/evil-yank-advice)

;; TODO: test todo
;; FIXME: test todo
;; REVIEW: test todo
;; HACK: test todo
;; DEPRECATED: test todo
;; NOTE: test todo
;; BUG: test todo
;; WARNING: test todo

(defvar r/todo-patterns nil)

(defun r//todo-pattern (keyword color)
  (list (concat "\\(\\s-*\\(" keyword "\\)\\(\s\\|:\\)\\)")
    (list 1 (list :background color :foreground (face-attribute 'default :background) :weight 'bold) t)
    (list 3 (list :background color :foreground color :weight 'bold) t)))

;; TODO: Make this into a macro
;; NOTE: Colors could be updated
;;;###autoload
(defun r//todo-update-patterns ()
  (let ((bg (face-attribute 'default :background))
        (todo (face-foreground 'warning))
        (fixme (face-foreground 'error))
        (review (face-foreground 'font-lock-keyword-face))
        (hack (face-foreground 'font-lock-constant-face))
        (deprecated (face-foreground 'font-lock-string-face))
        (note (face-foreground 'success))
        (bug (face-foreground 'error))
        (warning (face-foreground 'font-lock-constant-face)))
    (setq r/todo-patterns
      (list (r//todo-pattern "TODO" todo)
        (r//todo-pattern "FIXME" fixme)
        (r//todo-pattern "REVIEW" review)
        (r//todo-pattern "HACK" hack)
        (r//todo-pattern "DEPRECATED" deprecated)
        (r//todo-pattern "NOTE" note)
        (r//todo-pattern "BUG" bug)
        (r//todo-pattern "WARNING" warning)))))

(add-hook 'elpaca-after-init-hook #'r//todo-update-patterns)

(defun r/todo-apply-overlays (beg end)
  (r/todo-remove-overlays beg end)
  (let ((case-fold-search nil))
    (save-excursion
      (dolist (rule r/todo-patterns)
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
                (overlay-put ov 'r/todo t)))))))))

(defun r/todo-remove-overlays (beg end)
  (remove-overlays beg end 'r/todo t))

(defun r/todo-enable ()
  (jit-lock-register #'r/todo-apply-overlays))

(defun r/todo-disable ()
  (jit-lock-unregister #'r/todo-apply-overlays)
  (r/todo-remove-overlays (point-min) (point-max)))

(defun r/todo-reload-overlays (&rest _)
  (interactive)
  (r//todo-update-patterns)
  (dolist (buf (buffer-list))
    (when (buffer-local-value 'r/todo-mode buf)
      (with-current-buffer buf
        (r/todo-remove-overlays (point-min) (point-max))
        (jit-lock-refontify)))))

(defgroup rond nil
  "personal config group"
  :group 'convenience
  :prefix "r/")

(define-minor-mode r/todo-mode
  "Highlight TODO-style comment keywords."
  :lighter "r/todo-hl"
  (if r/todo-mode
    (r/todo-enable)
    (r/todo-disable)))

(defun r//todo-global-mode-turn-on ()
  (r/todo-mode 1))


(define-globalized-minor-mode r/todo-global-mode
  r/todo-mode
  r//todo-global-mode-turn-on
  :group 'rond)

(r/todo-global-mode 1)
(advice-add 'load-theme :after #'r/todo-reload-overlays)
(advice-add 'enable-theme :after #'r/todo-reload-overlays)


;;;###autoload
(defun sudo-remote-find-file (file)
  "Opens repote FILE with root privileges."
  (interactive "FFind file: ")
  (setq begin (replace-regexp-in-string  "scp" "ssh" (car (split-string file ":/"))))
  (setq end (car (cdr (split-string file "@"))))
  (set-buffer
    (find-file (format "%s" (concat begin "|sudo:root@" end)))))


;;;###autoload
(defun r/compile-from-clipboard ()
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
(defun r/eval-last-sexp ()
  (interactive)
  (let ((result (eval-last-sexp nil)))
    (kill-new (format "%S" result))
    (message "Result copied: %S" result)))

;;;###autoload
(defun r/dired-create-files-bulk (files)
  "Create multiple files at once. Type names separated by spaces."
  (interactive "sFiles to create: ")
  (let ((file-list (split-string files " " t)))
    (dolist (file file-list)
      (write-region "" nil (expand-file-name file dired-directory)))
    (revert-buffer)))

(after! dired
  (general-spc :keymaps 'dired-mode-map
    "n" #'r/dired-create-files-bulk))

(after! evil
  (advice-add 'evil-force-normal-state :after '(lambda () (evil-ex-execute "noh"))))


;; https://thanosapollo.org/posts/use-emacs-everywhere/
(defun r/wtype-text (text)
  "Process TEXT for wtype, handling newlines properly."
  (let* ((has-final-newline (string-match-p "\n$" text))
         (lines (split-string text "\n"))
         (last-idx (1- (length lines))))
    (string-join
      (cl-loop for line in lines
        for i from 0
        collect (cond
                  ;; Last line without final newline
                  ((and (= i last-idx) (not has-final-newline))
                   (format "wtype -s 350 \"%s\""
                     (replace-regexp-in-string "\"" "\\\\\"" line)))
                  ;; Any other line
                  (t
                    (format "wtype -s 350 \"%s\" && wtype -k Return"
                      (replace-regexp-in-string "\"" "\\\\\"" line)))))
      " && ")))

(defun r/type ()
  "Launch a temporary frame with a clean buffer for typing."
  (interactive)
  (let ((frame (make-frame '((name . "emacs-float")
                             (fullscreen . 0)
                             (undecorated . t)
                             (width . 70)
                             (height . 20))))
        (buf (get-buffer-create "emacs-float")))
    (select-frame frame)
    (switch-to-buffer buf)
    (erase-buffer)
    (org-mode)
    (setq-local header-line-format
      (format " %s to insert text or %s to cancel."
        (propertize "C-c C-c" 'face 'help-key-binding)
        (propertize "C-c C-k" 'face 'help-key-binding)))
    (local-set-key (kbd "C-c C-k")
      (lambda () (interactive)
        (kill-new (buffer-string))
        (delete-frame)))
    (local-set-key (kbd "C-c C-c")
      (lambda () (interactive)
        (start-process-shell-command
          "wtype" nil
          (r/wtype-text (buffer-string)))
        (delete-frame)))))



(provide 'r/util)
