;;; -*- lexical-binding: t -*-
(package! org
  :defer 4
  :config
  (add-hook 'after-init-hook 'org-mode)
  (add-hook 'after-init-hook #'org-indent-mode)
  (add-hook 'after-init-hook '(setq org-agenda-files (seq-filter (lambda(x) (not (string-match "\\/.#" x)))
                                                                 (directory-files-recursively "~/org" "\\.org$"))
                                    org-directory "~/org")))

(package! org-super-agenda
  :defer t)

(package! org-roam
  :defer t
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

(package! org-bullets
  :defer t)
(package! org-ql
  :defer t)
