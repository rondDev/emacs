;;; -*- lexical-binding: t -*-
(package! org)

(package! org-super-agenda
  :defer t)

(package! org-roam
  :defer t
  :custom
  (org-roam-directory (file-truename "/path/to/org-files/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)))

(package! org-modern
  ;; :disabled t
  :defer t
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
