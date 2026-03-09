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
                '((?- . "-"
                      (?* . "•")
                      (?+ . "‣")))
                org-modern-block-name '("" . ""))) ; or other chars; so top bracket is drawn promptly)

(after! org-auto-tangle
        (org-auto-tangle-mode))

(after! org-cliplink
        (general-spc
          "ol" #'org-cliplink))
