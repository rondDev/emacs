;;; init.el --- Initial config -*- lexical-binding: t -*-
;;; Version: 1.0.0
;; Add this before everything else in init.el

;; (defun trace-require (orig feature &rest args)
;;   (when (eq feature 'nerd-icons)
;;     (message "nerd-icons required by:") (backtrace))
;;   (apply orig feature args))
;; (advice-add 'require :around #'trace-require)

(add-hook 'elpaca-after-init-hook
          (lambda ()
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract (current-time) before-init-time)))
                     gcs-done)))

;; (load-theme 'modus-vivendi t) ; prevent flashbang

(when debug-on-error
  (profiler-start 'cpu+mem)
  (add-hook 'elpaca-after-init-hook
            (lambda () (profiler-stop)
              (profiler-report))))

;; new way to type y instead of yes
(add-hook 'elpaca-after-init-hook #'(lambda () (fset 'yes-or-no-p 'y-or-n-p)))

(add-to-list 'default-frame-alist '(font . "Iosevka Comfy 12"))

;; get doom mode line flicker and "nil" message otherwise
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (run-with-timer 1 nil (lambda ()
                                    (setq inhibit-message nil)))))
(setq ring-bell-function #'ignore)

(add-hook 'elpaca-after-init-hook #'global-hl-line-mode) ;; Highlight the current line in all buffers
(add-hook 'elpaca-after-init-hook #'save-place-mode)


(with-eval-after-load 'prog-mode
  (add-hook 'prog-mode-hook #'show-paren-local-mode))

(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(require 'uniquify)
(setq-default
 read-process-output-max (* 1024 1024))

(setq apropos-do-all t
      custom-file (expand-file-name "custom.el" user-emacs-directory)
      custom-safe-themes t
      display-line-numbers-type 'relative
      ediff-window-setup-function 'ediff-setup-windows-plain
      frame-inhibit-implied-resize t
      load-prefer-newer t
      mouse-yank-at-point t
      recentf-auto-cleanup 'never ;; disable before we start recentf!
      recentf-keep '(file-remote-p file-readable-p)
      save-interprogram-paste-before-kill t
      use-dialog-box nil ; no gui prompts
      use-package-compute-statistics t ; analyzes package load times
      visible-bell t
      uniquify-buffer-name-style 'forward)

(global-display-line-numbers-mode)

(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-close-windows activate)
  (let ((buffer-quit-function (lambda () ())))
    ad-do-it))

(column-number-mode)


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

(setq tramp-auto-save-directory rond-v/auto-save-folder)

;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (set-frame-parameter (selected-frame) 'alpha 100) "100 for fully opaque"
;;             (set-frame-parameter (selected-frame) 'background-alpha 100)))


(load (expand-file-name "lisp/elpaca-setup.el" user-emacs-directory))
(load (expand-file-name "modules/initial-packages.el" user-emacs-directory))

(package! recentf
  :ensure nil
  :defer 1
  :config
  (recentf-mode)
  (setq recentf-exclude '("^/[^/:]+:"))
  (setopt recentf-auto-cleanup 'never)
  (add-to-list 'recentf-exclude "/run/user/[0-9]+/gvfs")
  (add-to-list 'recentf-exclude "^/\\(gvfs\\|run/user\\)")
  :custom
  (recentf-max-menu-items 1000 "Offer more recent files in menu")
  (recentf-max-saved-items 1000 "Save more recent files"))

(package! no-littering
  :after 'savehist)

(package! savehist
  :ensure nil
  :config
  (savehist-mode 1))

;; No real effect on startup time
(package! benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'elpaca-after-init-hook 'benchmark-init/deactivate))

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "themes/*/*.el")))
(mapc 'load (file-expand-wildcards (concat user-emacs-directory "modules/*/*.el")))

(defvar rond//skip-dashboard nil)

(when (< 1 (length command-line-args))
  (setq rond//skip-dashboard t))

(package! welcome-dashboard
  :ensure (welcome-dashboard :host github :repo "konrad1977/welcome-dashboard")
  ;; :ensure nil
  ;; :load-path "~/code/welcome-dashboard"
  :when (not rond//skip-dashboard)
  :config
  (setq welcome-dashboard-use-nerd-icons t      ;; Use nerd icons instead of all-the-icons
        welcome-dashboard-path-max-length 75
        welcome-dashboard-show-file-path t      ;; Hide or show filepath
        welcome-dashboard-use-fahrenheit nil    ;; show in celcius or fahrenheit.
        welcome-dashboard-min-left-padding 10
        welcome-dashboard-image-file (expand-file-name "vapor.png" user-emacs-directory)
        welcome-dashboard-image-width 450
        welcome-dashboard-image-height 250
        welcome-dashboard-max-number-of-todos 5)
  ;; welcome-dashboard-title (concat "Welcome " user-full-name))
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




;;; init.el ends here
