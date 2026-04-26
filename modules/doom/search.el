;;; config/default/autoload/search.el -*- lexical-binding: t; -*-
;;;###autoload
(defun doom-region-active-p ()
  "Return non-nil if selection is active.
Detects evil visual mode as well."
  (declare (side-effect-free t))
  (or (use-region-p)
      (and (bound-and-true-p evil-local-mode)
           (evil-visual-state-p))))


;;;###autoload
(cl-defun +vertico-file-search (&key query in all-files (recursive t) prompt args)
  "Conduct a file search using ripgrep.

:query STRING
  Determines the initial input to search for.
:in PATH
  Sets what directory to base the search out of. Defaults to the current
  project's root.
:recursive BOOL
  Whether or not to search files recursively from the base directory.
:args LIST
  Arguments to be appended to `consult-ripgrep-args'."
  (declare (indent defun))
  (unless (executable-find "rg" t)
    (user-error "Couldn't find ripgrep in your PATH"))
  (require 'consult)
  (setq deactivate-mark t)
  (let* ((project-root (or (doom-project-root) default-directory))
         (directory (or in project-root))
         (consult-ripgrep-args
          (concat "rg "
                  (if all-files "-uu ")
                  (unless recursive "--maxdepth 1 ")
                  "--null --line-buffered --color=never --max-columns=1000 "
                  "--path-separator /   --smart-case --no-heading "
                  "--with-filename --line-number --search-zip "
                  "--hidden -g !.git -g !.svn -g !.hg "
                  (mapconcat #'identity args " ")))
         (prompt (if (stringp prompt) (string-trim prompt) "Search"))
         (query (or query
                    (when (doom-region-active-p)
                      (regexp-quote (doom-region)))))
         (consult-async-split-style consult-async-split-style)
         (consult-async-split-styles-alist
          (copy-sequence consult-async-split-styles-alist)))
    ;; Change the split style if the initial query contains the separator.
    (when query
      (cl-destructuring-bind (&key separator initial function)
          (alist-get consult-async-split-style consult-async-split-styles-alist)
        ;; Perl async split style starts with an #. If the query contains #,
        ;; then use oneof the alternative delimiters instead.
        (if (eq consult-async-split-style 'perl)
            (when (string-match-p (char-to-string initial) query)
              (setf (alist-get 'perlalt consult-async-split-styles-alist)
                    `(:initial ,(or (cl-loop for char in (list "%" "@" "!" "&" "/" ";")
                                             unless (string-match-p char query)
                                             return char)
                                    "%")
                               :seperator ,separator
                               :function ,function)
                    consult-async-split-style 'perlalt))
          ;; If the separator character is present *in* the query, escape them.
          (when separator
            (setq query
                  (replace-regexp-in-string (regexp-quote (char-to-string separator))
                                            (concat "\\" (char-to-string separator))
                                            query t t))))))
    (consult--grep prompt #'consult--ripgrep-make-builder directory query)))
;;;###autoload
(defun +vertico/project-search (&optional arg initial-query directory)
  "Performs a live project search from the project root using ripgrep.
If ARG (universal argument), include all files, even hidden or compressed ones,
in the search."
  (interactive "P")
  (+vertico-file-search :query initial-query :in directory :all-files arg))

;;;###autoload
(defun +vertico/project-search-from-cwd (&optional arg initial-query)
  "Performs a live project search from the current directory.
If ARG (universal argument), include all files, even hidden or compressed ones."
  (interactive "P")
  (+vertico/project-search arg initial-query default-directory))

;;;###autoload
(defun +vertico/search-symbol-at-point ()
  "Performs a search in the current buffer for thing at point."
  (interactive)
  (consult-line (thing-at-point 'symbol)))


;;;###autoload
(defun +default/search-cwd (&optional arg)
  "Conduct a text search in files under the current folder.
If prefix ARG is set, prompt for a directory to search from."
  (interactive "P")
  (let ((default-directory
         (if arg
             (read-directory-name "Search directory: ")
           default-directory)))
    (call-interactively
     #'+vertico/project-search-from-cwd)))

;;;###autoload
(defun +default/search-other-cwd ()
  "Conduct a text search in another directory."
  (interactive)
  (+default/search-cwd 'other))

;;;###autoload
(defun +default/search-emacsd ()
  "Conduct a text search in files under `doom-emacs-dir'."
  (interactive)
  (let ((default-directory doom-emacs-dir))
    (call-interactively
     (#'+vertico/project-search-from-cwd))))

;;;###autoload
(defun +default/search-buffer ()
  "Conduct a text search on the current buffer.

If a selection is active and multi-line, perform a search restricted to that
region.

If a selection is active and not multi-line, use the selection as the initial
input and search the whole buffer for it."
  (interactive)
  (let (start end multiline-p)
    (save-restriction
      (when (region-active-p)
        (setq start (region-beginning)
              end   (region-end)
              multiline-p (/= (line-number-at-pos start)
                              (line-number-at-pos end)))
        (deactivate-mark)
        (when multiline-p
          (narrow-to-region start end)))
      (if (and start end (not multiline-p))
          (consult-line
           (replace-regexp-in-string
            " " "\\\\ "
            (doom-pcre-quote
             (buffer-substring-no-properties start end))))
        (call-interactively #'consult-line)))))

;;;###autoload
(defun +default/search-project (&optional arg)
  "Conduct a text search in the current project root.
If prefix ARG is set, include ignored/hidden files."
  (interactive "P")
  (let* ((projectile-project-root nil)
         (disabled-command-function nil)
         (current-prefix-arg (unless (eq arg 'other) arg))
         (default-directory
          (if (eq arg 'other)
              (if-let* ((projects (projectile-relevant-known-projects)))
                  (completing-read "Search project: " projects nil t)
                (user-error "There are no known projects"))
            default-directory)))
    (call-interactively
     #'+vertico/project-search
     #'projectile-ripgrep)))

;;;###autoload
(defun +default/search-other-project ()
  "Conduct a text search in a known project."
  (interactive)
  (+default/search-project 'other))

;;;###autoload
(defun +default/search-project-for-symbol-at-point (symbol dir)
  "Search current project for symbol at point.
If prefix ARG is set, prompt for a known project to search from."
  (interactive
   (list (or (doom-thing-at-point-or-region) "")
         (let ((projectile-project-root nil))
           (if current-prefix-arg
               (if-let* ((projects (projectile-relevant-known-projects)))
                   (completing-read "Search project: " projects nil t)
                 (user-error "There are no known projects"))
             (doom-project-root default-directory)))
         (+vertico/project-search nil symbol dir))))

;;;###autoload
(defun +default/search-notes-for-symbol-at-point (symbol)
  "Conduct a text search in the current project for symbol at point. If prefix
ARG is set, prompt for a known project to search from."
  (interactive
   (list (doom-pcre-quote (or (doom-thing-at-point-or-region) ""))))
  (require 'org)
  (+default/search-project-for-symbol-at-point
   symbol org-directory))

;;;###autoload
(defun +default/org-notes-search (query)
  "Perform a text search on `org-directory'."
  (interactive
   (list (if (doom-region-active-p)
             (buffer-substring-no-properties
              (doom-region-beginning)
              (doom-region-end))
           "")))
  (require 'org)
  (+default/search-project-for-symbol-at-point
   query org-directory))

;;;###autoload
(defun +default/org-notes-headlines ()
  "Jump to an Org headline in `org-agenda-files'."
  (interactive)
  (doom-completing-read-org-headings
   "Jump to org headline: " org-agenda-files
   :depth 3
   :include-files t))
