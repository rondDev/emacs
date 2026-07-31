;; -*- lexical-binding: t; -*-
(package! persp-projectile
  :after (projectile))

(package! perspective)

(package! projectile
  :after (general)
  :init
  (setq projectile-project-search-path '("~/code" "~/.config" ("~/projects" . 2))
    projectile-enable-caching t
    projectile-sort-order 'recently-active)
  (projectile-mode +1)
  (add-hook 'elpaca-after-init-hook #'projectile-discover-projects-in-search-path)
  (add-hook 'elpaca-after-init-hook #'projectile-load-known-projects))

(package! projectile-git-autofetch
  :after projectile
  :init
  (after! projectile
    (add-hook 'emacs-startup-hook #'projectile-git-autofetch-setup)))
