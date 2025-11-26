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
(defun rond/reset-gc-value ()
  (run-with-idle-timer
   1 nil
   (lambda ()
     ;; (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value)))
     ;; https://github.com/emacs-lsp/lsp-mode#performance
     ;; TODO try out different values
     (setq gc-cons-threshold 100000000)
     (when rond//debug (message "gc-cons-threshold restored to %S" gc-cons-threshold)))))
(add-hook 'elpaca-after-init-hook #'rond/reset-gc-value)

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

(savehist-mode t)

(load (expand-file-name "lisp/elpaca-setup.el" user-emacs-directory))
(load (expand-file-name "modules/initial-packages.el" user-emacs-directory))

(use-package no-littering
  :after 'savehist)

;; No real effect on startup time
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; TODO: Improve this loading, it's really messy
(load (expand-file-name "modules/default/keybindings.el" user-emacs-directory))
(load (expand-file-name "modules/default/packages.el" user-emacs-directory))
(load (expand-file-name "modules/git/packages.el" user-emacs-directory))
(load (expand-file-name "modules/lang/packages.el" user-emacs-directory))
(load (expand-file-name "modules/lang/lsp.el" user-emacs-directory))
(load (expand-file-name "modules/org/packages.el" user-emacs-directory))
(load (expand-file-name "modules/ui/packages.el" user-emacs-directory))
(load (expand-file-name "lisp/tramp.el" user-emacs-directory))

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "themes/*/*.el")))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(advice-add 'package-install :before '(package-initialize))


(use-package welcome-dashboard
  ;; TODO: Change repo URL to upstream once this is merged: https://github.com/konrad1977/welcome-dashboard/pull/14
  :ensure (welcome-dashboard :host github :repo "rondDev/welcome-dashboard")
  :config
  (setq welcome-dashboard-latitude 56.7365
        welcome-dashboard-longitude 16.2981     ;; latitude and longitude must be set to show weather information
        welcome-dashboard-use-nerd-icons t      ;; Use nerd icons instead of all-the-icons
        welcome-dashboard-path-max-length 75
        welcome-dashboard-show-file-path t      ;; Hide or show filepath
        welcome-dashboard-use-fahrenheit nil    ;; show in celcius or fahrenheit.
        welcome-dashboard-min-left-padding 10
        welcome-dashboard-image-file "~/path/yourimage.png"
        welcome-dashboard-image-width 200
        welcome-dashboard-image-height 169
        welcome-dashboard-max-number-of-todos 5
        welcome-dashboard-title (concat "Welcome " user-full-name))
  (add-hook 'window-configuration-change-hook #'welcome-dashboard--redisplay-buffer-on-resize)
  (add-hook 'emacs-startup-hook (lambda ()
                                  ;; Show dashboard immediately
                                  (welcome-dashboard--refresh-screen)
                                  ;; Defer loading of additional data - only weather, no TODOs
                                  (run-with-idle-timer 2.0 nil #'welcome-dashboard--fetch-weather-data t)
                                  ;; Update time every minute when dashboard is active
                                  (run-with-timer 60 60 (lambda () 
                                                          (when (welcome-dashboard--isActive)
                                                            (welcome-dashboard--refresh-screen)))))))




(run-hooks 'rond/after-init-hook)
;;; init.el ends here
