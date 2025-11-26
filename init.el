;;; init.el --- Initial config -*- lexical-binding: t -*-
;;; Version: 1.0.0

(defvar rond/debug nil
  "Custom debug mode")
(defvar rond//debug-report nil)
;; (trace-function 'run-hooks)
(defvar rond/after-init-hook nil)

(load-theme 'modus-vivendi t) ; prevent flashbang

(when rond//debug
  (profiler-start 'cpu+mem)
  (add-hook 'elpaca-after-init-hook
            (lambda () (profiler-stop)
              (when rond//debug-report (profiler-report))))
  (toggle-debug-on-error))

(add-to-list 'default-frame-alist '(font . "Iosevka Comfy 12"))

;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
;; huge impact to profile-dotemacs results; GC takes up a lot of init time
(setq gc-cons-threshold most-positive-fixnum) ; pls no garbage collection in init

;; reset gc-cons-threshold
(run-with-idle-timer
 10 nil
 (lambda ()
   ;; (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value)))
   ;; https://github.com/emacs-lsp/lsp-mode#performance
   ;; TODO try out different values
   (setq gc-cons-threshold 100000000)
     (when rond//debug (message "gc-cons-threshold restored to %S" gc-cons-threshold)))))

;; new way to type y instead of yes
(add-hook 'after-init-hook #'(lambda () (fset 'yes-or-no-p 'y-or-n-p)))

(setq load-prefer-newer t
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      use-dialog-box nil ; no gui prompts
      use-package-compute-statistics t ; analyzes package load times
      custom-safe-themes t)

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
(setq recentf-keep '(file-remote-p file-readable-p))
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



                        ;;; Tramp
;; TRAMP performance settings
(setq tramp-use-ssh-controlmaster-options nil) ; Use your SSH config instead
(setq tramp-default-method "scp")             ; Force SSH method
(setq password-cache-expiry 3600)             ; Cache passwords longer

;; For faster connection establishment
(setq tramp-connection-timeout 10)
(setq tramp-verbose 3) ; Reduce if too verbose, increase for debugging
(setq remote-file-name-inhibit-locks t
      tramp-use-scp-direct-remote-copying t
      remote-file-name-inhibit-auto-save-visited t)
(setq tramp-copy-size-limit (* 8 1024 1024) ;; 8MB
      tramp-verbose 2)

(connection-local-set-profile-variables
 'remote-direct-async-process
 '((tramp-direct-async-process . t)))

(connection-local-set-profiles
 '(:application tramp :protocol "scp")
 'remote-direct-async-process)

(setq magit-tramp-pipe-stty-settings 'pty)

(with-eval-after-load 'tramp
  (with-eval-after-load 'compile
    (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options)))


(when (file-executable-p "/usr/sbin/fish")
  (setq shell-file-name (executable-find
                         "fish"))
  (setq-default vterm-shell
                "/usr/sbin/fish")
  (setq-default explicit-shell-file-name
                "/usr/sbin/fish"))


(setq vterm-eval-cmds '(("find-file" find-file)
                        ("message" message)
                        ("vterm-clear-scrollback" vterm-clear-scrollback)
                        ("dired" dired)
                        ("ediff-files" ediff-files)))
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))

(setq projectile-mode-line "Projectile")

;; ;; NOTE: Does not work for compile mode
;; (add-hook 'prog-mode-hook 
;;           '(lambda () (interactive)(defadvice split-window (after move-point-to-new-window activate)
;;                                      "Moves the point to the newly created window after splitting."
;;                                      (other-window 1))))


(savehist-mode t)

(use-package no-littering
  :after 'savehist)

;; NOTE: Fixes ansi colors in compilation mode
(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))

;; (mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/*/*.el")))
;; TODO: Improve this loading, it's really messy
(load (expand-file-name "lisp/elpaca-setup.el" user-emacs-directory))

;; No real effect on startup time
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(load (expand-file-name "modules/initial-packages.el" user-emacs-directory))
(load (expand-file-name "modules/default/keybindings.el" user-emacs-directory))
(load (expand-file-name "modules/default/packages.el" user-emacs-directory))
(load (expand-file-name "modules/git/packages.el" user-emacs-directory))
(load (expand-file-name "modules/lang/packages.el" user-emacs-directory))
(load (expand-file-name "modules/lang/lsp.el" user-emacs-directory))
(load (expand-file-name "modules/org/packages.el" user-emacs-directory))
                                        ; (load (expand-file-name "modules/org.el" user-emacs-directory))
(load (expand-file-name "modules/ui/packages.el" user-emacs-directory))


(mapc 'load (file-expand-wildcards (concat user-emacs-directory "themes/*/*.el")))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (package-initialize)

(run-with-idle-timer 5 nil '(lambda () (run-hooks 'rond/after-init-hook)))

