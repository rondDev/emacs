;;; -*- lexical-binding: t -*-
(package! evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(package! ob-deno
  :after org
  :config
  (org-babel-do-load-languages 'org-babel-load-languages '((deno . t))))
(package! ob-go
  :after org
  :ensure (ob-go
           :host github
           :repo "pope/ob-go")
  :config
  (org-babel-do-load-languages 'org-babel-load-languages '((go . t))))
(package! ob-http
  :after org
  :config
  (org-babel-do-load-languages 'org-babel-load-languages '((http . t))))
(package! ob-rust
  :after org
  :config
  (org-babel-do-load-languages 'org-babel-load-languages '((rust . t))))

(package! org
  :defer 4
  :hook (org-mode . org-indent-mode)
  :config
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


(package! org-super-agenda
  :defer t)

(package! org-roam
  :after org
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(package! org-modern
  ;; :disabled t
  :custom
  (org-modern-hide-stars nil) ; adds extra indentation
  (org-modern-table t)
  (org-modern-list
   '((?- . "-")
     (?* . "•")
     (?+ . "‣")))
  (org-modern-block-name '("" . "")) ; or other chars; so top bracket is drawn promptly
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(package! org-superstar
  :ensure (org-superstar :host github :repo "integral-dw/org-superstar-mode")
  :after (org))

(package! org-ql
  :defer t)

(package! org-auto-tangle
  :after org
  :defer 3
  :config
  (org-auto-tangle-mode))

(package! org-cliplink
  :config
  (general-spc
    "ol" #'org-cliplink))
