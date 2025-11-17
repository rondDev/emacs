;;; -*- lexical-binding: t -*-
(after! org
  (add-hook 'after-init-hook 'org-mode)
  (add-hook 'after-init-hook #'org-indent-mode)
  (add-hook 'after-init-hook '(setq org-agenda-files (seq-filter (lambda(x) (not (string-match "\\/.#" x)))
 		  (directory-files-recursively "~/org" "\\.org$"))
        org-directory "~/org")))

(after! org-roam
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  (after! general
    (general)))

(after! org-modern
  (add-hook 'org-mode #'org-modern-mode)
  (add-hook 'org-agenda-finalize #'org-modern-agenda))

(after! org-bullets
  (add-hook 'org-mode-hook #'org-bullets-mode))
