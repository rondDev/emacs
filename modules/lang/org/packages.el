;;; -*- lexical-binding: t -*-
(package! evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode)))

(package! ob-deno
  :after org)

(package! ob-go
  :after org
  :ensure (ob-go
           :host github
           :repo "pope/ob-go"))

(package! ob-http
  :after org)

(package! ob-rust
  :after org)

(package! org
  :defer t
  :hook (org-mode . org-indent-mode))

(package! org-super-agenda
  :defer t)

(package! org-roam
  :after org
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)))

(package! org-modern
  ;; :disabled t
  :after org
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
  :defer 3)

(package! org-cliplink
  :after org)
