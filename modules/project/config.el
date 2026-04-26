;; -*- lexical-binding: t; -*-
(after! persp-projectile
        (setq persp-mode-prefix-key "SPC.")
        (persp-mode))

(after! perspective
        (defun persp-new (name)
          "Return a perspective named NAME, or create a new one if missing.
The new perspective will start with only an `initial-major-mode'
buffer called \"*scratch* (NAME)\"."
          (or (gethash name (perspectives-hash))
              (make-persp :name name
                (persp-reset-windows)))))

(after! projectile-git-autofetch
        (setopt projectile-git-autofetch-notify nil)
        (setopt projectile-git-autofetch-interval 60)
        (setopt projectile-git-autofetch-fetch-args '("--no-progress" "--prune" "--prune-tags")))
