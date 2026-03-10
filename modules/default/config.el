(after! ace-window
        (setopt aw-dispatch-always t)
        ;; NOTE: which-key might not work here, unsure
        (general-spc
          "j" #'ace-window
          "jx" '(:ignore t :wk "delete window")
          "jm" '(:ignore t :wk "swap windows")
          "jM" '(:ignore t :wk "move window")
          "jc" '(:ignore t :wk "copy window")
          "jj" '(:ignore t :wk "select buffer")
          "jn" '(:ignore t :wk "select previous buffer")
          "ju" '(:ignore t :wk "select buffer in other window")
          "jc" '(:ignore t :wk "split fairly")
          "jv" '(:ignore t :wk "split vertically")
          "jb" '(:ignore t :wk "split horizontally")
          "jo" '(:ignore t :wk "maximize current window")
          "j?" '(:ignore t :wk "show bindings"))
        (setq aw-keys '(?a ?s ?d ?f ?g ?h ?k ?l
                           aw-dispatch-always t)))

(after! async
        (async-bytecomp-package-mode 1))

(after! autorevert
        (setopt auto-revert-interval 0.01) ; "Instantaneously revert"
        (global-auto-revert-mode t))

(after! auto-sudoedit
        (auto-sudoedit-mode 1)) ; automatically open with sudo

(after! compile
        (defun +compilation-colorize ()
          "Colorize from `compilation-filter-start' to `point'."
          (require 'ansi-color)
          (let ((inhibit-read-only t))
            (ansi-color-apply-on-region (point-min) (point-max))))
        (add-hook 'compilation-filter-hook #'+compilation-colorize))

(after! dired
        (setopt dired-mouse-drag-files t)
        (setopt dired-listing-switches "-alh") ;"Human friendly file sizes."
        (setopt dired-kill-when-opening-new-dired-buffer t)
        (setopt dired-omit-files "\\(?:\\.+[^z-a]*\\)")
        ;; (add-hook 'dired-mode-hook 'dired-omit-mode)
        (dired-async-mode 1))

(after! editorconfig
        (editorconfig-mode 1))

(after! evil-collection
        (setq evil-collection-magit-use-z-for-folds t
              evil-collection-magit-use-y-for-yank t)
        (setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes)))

(after! evil-nerd-commenter
        (evilnc-default-hotkeys))

(after! evil-surround
        (global-evil-surround-mode 1))

(after! evil-quickscope
        (evil-quickscope-always-mode))

(after! exec-path-from-shell
        (add-hook 'emacs-startup-hook #'exec-path-from-shell-initialize))

(after! orderless
        (setq completion-styles '(orderless basic))
        (setq completion-category-overrides '((file (styles partial-completion))))
        (setq completion-category-defaults nil)
        (setq completion-pcm-leading-wildcard t))

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

(after! smartparens
        (require 'smartparens-config)) ;; add `smartparens-mode` to these hooks

(after! undo-fu
        (setq undo-limit 67108864) ; 64mb.
        (setq undo-strong-limit 100663296) ; 96mb.
        (setq undo-outer-limit 1006632960)) ; 960mb.

(after! vertico
        (setq vertico-cycle t)
        (setq vertico-count 20)
        (setq vertico-resize nil)
        (add-hook 'pre-command-hook #'vertico-mode))

(after! wakatime-mode
        (when (file-executable-p "/usr/sbin/wakatime")
          (global-wakatime-mode)))
