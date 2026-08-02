;; -*- lexical-binding: t; -*-
(after! evil-org
        (require 'evil-org-agenda)
        (evil-org-agenda-set-keys))

(after! ob-deno
        (org-babel-do-load-languages 'org-babel-load-languages '((deno . t))))

(after! ob-go
        (org-babel-do-load-languages 'org-babel-load-languages '((go . t))))

(after! ob-http
        (org-babel-do-load-languages 'org-babel-load-languages '((http . t))))

(after! ob-rust
        (org-babel-do-load-languages 'org-babel-load-languages '((rust . t))))

(after! org
        (comma-def!
          :keymaps 'org-mode-map
          :states '(normal visual motion)
          ",o" #'org-insert-structure-template)
        (general-spc
          "oa" #'org-agenda)
        (add-hook 'after-init-hook 'org-mode)
        (add-hook 'after-init-hook #'org-indent-mode)
        (when (file-exists-p "~/org")
          (setq org-agenda-files (directory-files-recursively "~/org" "\\.org$")
                org-directory "~/org"))
        (setq org-structure-template-alist
              '(("s" . "src")
                ("e" . "src emacs-lisp")
                ("E" . "src emacs-lisp :results value code :lexical t")
                ("t" . "src emacs-lisp :tangle FILENAME")
                ("T" . "src emacs-lisp :tangle FILENAME :mkdirp yes")
                ("x" . "example")
                ("X" . "export")
                ("q" . "quote")))
        ;; NOTE: Taken from Doom Emacs
        (setq org-todo-keywords
              '((sequence "TODO(t!)" "PROJ(p!)" "LOOP(r!)" "STRT(s!)" "WAIT(w!)" "HOLD(h!)" "IDEA(i!)" "|" "DONE(d!)" "KILL(k!)")
                (sequence "[ ](T!)" "[-](S!)" "[?](W!)" "|" "[X](D!)")
                (sequence "|" "OKAY(o!)" "YES(y!)" "NO(n!)")))
        (after! org
                (org-babel-do-load-languages
                 'org-babel-load-languages
                 '(
                   (awk . t)
                   (calc .t)
                   (C . t)
                   (emacs-lisp . t)
                   (haskell . t)
                   (gnuplot . t)
                   (latex . t)
                   ;;(ledger . t)
                   (js . t)
                   (haskell . t)
                   (perl . t)
                   (python . t)
                   ;; (gnuplot . t)
                   ;; org-babel does not currently support php.  That is really sad.
                   ;;(php . t)
                   (R . t)
                   (scheme . t)
                   ;; (sh . t)
                   (sql . t)
                   (sqlite . t)))))

(after! org-roam
        (setopt org-roam-directory (file-truename "~/org/roam/"))
        ;; If you're using a vertical completion framework, you might want a more informative completion interface
        (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
        (org-roam-db-autosync-mode)
        ;; If using org-roam-protocol
        (require 'org-roam-protocol))

(after! org-modern
        (setopt org-modern-hide-stars nil ; adds extra indentation
                org-modern-table t
                org-modern-list
                '((?- . "-")
                  (?* . "•")
                  (?+ . "‣"))
                org-modern-checkbox '((88 . "󰄳 ") (45 . #("□–" 0 2 (composition ((2))))) (32 . "󰄰 "))
                org-modern-block-name '("" . ""))) ; or other chars; so top bracket is drawn promptly)

(after! org-auto-tangle
        (org-auto-tangle-mode))

(after! org-cliplink
        (general-spc
          "ol" #'org-cliplink))


(after! org
  (defun +org--insert-item (direction)
    (let ((context (org-element-lineage
                    (org-element-context)
                    '(table table-row headline inlinetask item plain-list)
                    t)))
      (pcase (org-element-type context)
        ;; Add a new list item (carrying over checkboxes if necessary)
        ((or `item `plain-list)
         (let ((orig-point (point)))
           ;; Position determines where org-insert-todo-heading and `org-insert-item'
           ;; insert the new list item.
           (if (eq direction 'above)
               (org-beginning-of-item)
             (end-of-line))
           (let* ((ctx-item? (eq 'item (org-element-type context)))
                  (ctx-cb (org-element-property :contents-begin context))
                  ;; Hack to handle edge case where the point is at the
                  ;; beginning of the first item
                  (beginning-of-list? (and (not ctx-item?)
                                           (= ctx-cb orig-point)))
                  (item-context (if beginning-of-list?
                                    (org-element-context)
                                  context))
                  ;; Horrible hack to handle edge case where the
                  ;; line of the bullet is empty
                  (ictx-cb (org-element-property :contents-begin item-context))
                  (empty? (and (eq direction 'below)
                               ;; in case contents-begin is nil, or contents-begin
                               ;; equals the position end of the line, the item is
                               ;; empty
                               (or (not ictx-cb)
                                   (= ictx-cb
                                      (1+ (point))))))
                  (pre-insert-point (point)))
             ;; Insert dummy content, so that `org-insert-item'
             ;; inserts content below this item
             (when empty?
               (insert " "))
             (org-insert-item (org-element-property :checkbox context))
             ;; Remove dummy content
             (when empty?
               (delete-region pre-insert-point (1+ pre-insert-point))))))
        ;; Add a new table row
        ((or `table `table-row)
         (pcase direction
           ('below (save-excursion (org-table-insert-row t))
                   (org-table-next-row))
           ('above (save-excursion (org-shiftmetadown))
                   (+org/table-previous-row))))

        ;; Otherwise, add a new heading, carrying over any todo state, if
        ;; necessary.
        (_
         (let ((level (or (org-current-level) 1)))
           ;; I intentionally avoid `org-insert-heading' and the like because they
           ;; impose unpredictable whitespace rules depending on the cursor
           ;; position. It's simpler to express this command's responsibility at a
           ;; lower level than work around all the quirks in org's API.
           (pcase direction
             (`below
              (let (org-insert-heading-respect-content)
                (goto-char (line-end-position))
                (org-end-of-subtree)
                (insert "\n" (make-string level ?*) " ")))
             (`above
              (org-back-to-heading)
              (insert (make-string level ?*) " ")
              (save-excursion (insert "\n"))))
           (run-hooks 'org-insert-heading-hook)
           (when-let* ((todo-keyword (org-element-property :todo-keyword context))
                       (todo-type    (org-element-property :todo-type context)))
             (org-todo
              (cond ((eq todo-type 'done)
                     ;; Doesn't make sense to create more "DONE" headings
                     (car (+org-get-todo-keywords-for todo-keyword)))
                    (todo-keyword)
                    ('todo)))))))

      (when (org-invisible-p)
        (org-show-hidden-entry))
      (when (and (bound-and-true-p evil-local-mode)
                 (not (evil-emacs-state-p)))
        (evil-insert 1))))
  (def!
    :states '(normal visual motion insert)
    :keymaps '(org-mode-map)
    "C-<return>" '(lambda () (interactive) (+org--insert-item 'below))))

;;;###autoload
(defun +org-get-todo-keywords-for (&optional keyword)
  "Returns the list of todo keywords that KEYWORD belongs to."
  (when keyword
    (cl-loop for (type . keyword-spec)
             in (cl-remove-if-not #'listp org-todo-keywords)
             for keywords =
             (mapcar (lambda (x) (if (string-match "^\\([^(]+\\)(" x)
                                     (match-string 1 x)
                                   x))
                     keyword-spec)
             if (eq type 'sequence)
             if (member keyword keywords)
             return keywords)))
