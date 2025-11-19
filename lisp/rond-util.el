;;;###autoload
(defmacro after! (package &rest body)
   `(with-eval-after-load ',package ,@body))

;;;###autoload
(defmacro s-map! (&rest body)
  "Safe mapping for keybinds"
   `(after! general (general-define-key ,@body)))

;;;###autoload
(defalias 'package! 'use-package)

;; Needed for maxing contrast
(package! ct)

(defvar rond/todo-patterns nil)
(defun rond/todo-max-contrast (face &optional ratio &rest args)
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

(defun rond/todo-update-highlights (&rest args)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when rond/todo-outline-mode
        (font-lock-remove-keywords nil rond/todo-patterns)
        (rond/todo-update-patterns)
        (font-lock-add-keywords nil rond/todo-patterns)
        (font-lock-flush)))))

;; Initialize patterns
(rond/todo-update-patterns)

(define-minor-mode rond/todo-outline-mode
  "Highlight TODOs with theme background for colon."
  :global nil
  (if rond/todo-outline-mode
      (font-lock-add-keywords nil rond/todo-patterns)
    (font-lock-remove-keywords nil rond/todo-patterns))
  (when font-lock-mode (font-lock-flush)))

(add-hook 'prog-mode-hook #'rond/todo-outline-mode)
(advice-add 'enable-theme :after #'rond/todo-update-highlights)


(provide 'rond/util)
