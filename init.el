;;; init.el -*- lexical-binding: t -*-

;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
;; huge impact to profile-dotemacs results; GC takes up a lot of init time
(defvar rond/debug nil
  "Custom debug mode")
  
;; (trace-function 'run-hooks)
(defvar rond/after-init-hook nil)

(load-theme 'modus-vivendi t) ; prevent flashbang
(when rond/debug (profiler-start 'cpu+mem))
(setq use-package-compute-statistics t) ; analyzes package load times
(setq custom-safe-themes t)
(add-to-list 'default-frame-alist '(font . "Iosevka Comfy 14"))
(setq gc-cons-threshold most-positive-fixnum) ; pls no garbage collection in init

;; reset gc-cons-threshold
(run-with-idle-timer
 10 nil
 (lambda ()
   ;; (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value)))
   ;; https://github.com/emacs-lsp/lsp-mode#performance
   ;; TODO try out different values
   (setq gc-cons-threshold 100000000)
   (when rond/debug (message "gc-cons-threshold restored to %S" gc-cons-threshold))))

;; new way to type y instead of yes
(add-hook 'after-init-hook #'(lambda () (fset 'yes-or-no-p 'y-or-n-p)))

(setq load-prefer-newer t
      ;; TODO check if `vc-follow-symlinks' is needed and works without this
      ;; I don't use vc
      ;; https://www.reddit.com/r/emacs/comments/4c0mi3/the_biggest_performance_improvement_to_emacs_ive/
      ;; https://magit.vc/manual/magit/Performance.html
      ;; required for `diff-hl'
      ;; vc-handled-backends nil
      ;; don't want emacs touching this file
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      ;; no GUI prompts
      use-dialog-box nil)

;; get doom mode line flicker and "nil" message otherwise
(add-hook 'after-init-hook
          (lambda ()
            (run-with-timer 1 nil (lambda ()
                                    (setq inhibit-message nil)))))
(setq ring-bell-function #'ignore)

(add-hook 'emacs-startup-hook #'global-auto-revert-mode)
(add-hook 'emacs-startup-hook #'global-hl-line-mode) ;; Highlight the current line in all buffers
(add-hook 'emacs-startup-hook #'save-place-mode)
(with-eval-after-load 'prog-mode
  (add-hook 'prog-mode-hook #'show-paren-local-mode))

(setq-default indent-tabs-mode nil)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      visible-bell t
      load-prefer-newer t
      backup-by-copying t
      frame-inhibit-implied-resize t
      ediff-window-setup-function 'ediff-setup-windows-plain
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      read-process-output-max (* 32 1024 1024))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-close-windows activate)
  (let ((buffer-quit-function (lambda () ())))
    ad-do-it))

(column-number-mode)
(setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
(recentf-mode)

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(add-hook 'emacs-startup-hook (lambda ()
                                (when (get-buffer-window "*Messages*")
                                  (bury-buffer "*Messages*"))))
(add-hook 'emacs-startup-hook (lambda ()
                                (when (get-buffer-window "*scratch*")
                                  (bury-buffer "*scratch*"))))
(unless backup-directory-alist
  (defvar rond/tmpdir "/tmp/backup"
    "Temp directory to use")
  (when (not (file-directory-p rond/tmpdir))
    (make-directory rond/tmpdir))
  (setq backup-directory-alist `(("." . , rond/tmpdir))))

(defvar rond-v/auto-save-folder (expand-file-name "tmp/auto-saves/" user-emacs-directory))
(defvar rond-v/lockfile-folder (expand-file-name "tmp/lockfiles/" user-emacs-directory))
(make-directory rond-v/auto-save-folder t)
(setq auto-save-file-name-transforms `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat rond-v/auto-save-folder "\\1") t)))
(setq lock-file-name-transforms `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat rond-v/lockfile-folder "\\1") t)))

(setq tramp-auto-save-directory rond-v/auto-save-folder)

(unless (native-comp-available-p)
  (warn "Native compilation not available"))


(add-hook 'after-make-frame-functions
          (lambda (frame)
            (set-frame-parameter (selected-frame) 'alpha 100) "100 for fully opaque"
            (set-frame-parameter (selected-frame) 'background-alpha 100)))

;; (mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/*/*.el")))
;; TODO: Improve this loading, it's really messy
(load (expand-file-name "lisp/elpaca-setup.el" user-emacs-directory))
(load (expand-file-name "modules/initial-packages.el" user-emacs-directory))
(load (expand-file-name "modules/default/keybindings.el" user-emacs-directory))
(load (expand-file-name "modules/default/packages.el" user-emacs-directory))
(load (expand-file-name "modules/git/packages.el" user-emacs-directory))
(load (expand-file-name "modules/lang/packages.el" user-emacs-directory))
;; (load (expand-file-name "modules/org/packages.el" user-emacs-directory))
                                        ; (load (expand-file-name "modules/org.el" user-emacs-directory))
(load (expand-file-name "modules/ui/packages.el" user-emacs-directory))


(mapc 'load (file-expand-wildcards (concat user-emacs-directory "themes/*/*.el")))

;; (add-hook 'after-init-hook #'(set-frame-font "Iosevka Comfy 10" nil t))

;; (profiler-stop)
(add-hook 'emacs-startup-hook (lambda ()
                                (when (get-buffer-window "*scratch*")
                                  (bury-buffer "*scratch*"))))
