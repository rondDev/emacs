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
(cl-pushnew (expand-file-name "lisp" user-emacs-directory)
            load-path :test #'string=)

(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp/rond-util.el")))
(autoload 'after! (expand-file-name "lisp/rond-util.el" user-emacs-directory))


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
      


; (setq debug-on-error nil
;       debug-on-quit nil)

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Uncomment for systems which cannot create symlinks:
;; (elpaca-no-symlink-mode)

;; Install a package via the elpaca macro
;; See the "recipes" section of the manual for more details.

;; (elpaca example-package)


;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode)
  (setq use-package-always-ensure t))
(elpaca-wait)

;; (setq use-package-always-defer t)

;; No real effect on startup time
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
 (add-hook 'after-init-hook 'benchmark-init/deactivate))

(use-package savehist
  :ensure nil
  :config
 (savehist-mode t))
  
(use-package no-littering
  :after 'savehist)

;; get doom mode line flicker and "nil" message otherwise
(add-hook 'after-init-hook
          (lambda ()
            (run-with-timer 1 nil (lambda ()
                                    (setq inhibit-message nil)))))

(use-package evil
  :ensure (:wait t)
 :init
 (setq evil-want-keybinding nil)
 (setq evil-kill-on-visual-paste nil)
 (setq evil-want-C-u-scroll t)
 (setq evil-want-C-i-jump nil)
 (setq evil-undo-system 'undo-fu)
 :config
 (evil-mode)
   ;; Place the cursor in the new window after a horizontal split
 (setq evil-split-window-below t)
  ;; Place the cursor in the new window after a vertical split
 (setq evil-vsplit-window-right t)

 (after! evil-collection
   (evil-collection-init)
   (setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))))

(use-package general
  :ensure (:wait t))

;;Turns off elpaca-use-package-mode current declaration
;; NOTE this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
(use-package emacs :ensure nil :config (setq ring-bell-function #'ignore))

(add-hook 'emacs-startup-hook #'global-auto-revert-mode)
(add-hook 'emacs-startup-hook #'global-hl-line-mode) ;; Highlight the current line in all buffers
(add-hook 'emacs-startup-hook #'save-place-mode)
;; (save-place-mode 1)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)
;; (show-paren-mode 1)
(with-eval-after-load 'prog-mode
  (add-hook 'prog-mode-hook #'show-paren-local-mode))

;; (tooltip-mode -1) ;; Don't display tooltips as popups, use the echo area instead
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

; (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))

; (load (locate-user-emacs-file "config.el"))
; (load (locate-user-emacs-file "modules/default/config"))
; (load (locate-user-emacs-file "modules/default/packages"))

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
(load (expand-file-name "modules/default/keybindings.el" user-emacs-directory))
(load (expand-file-name "modules/default/packages.el" user-emacs-directory))
(load (expand-file-name "modules/git/packages.el" user-emacs-directory))
(load (expand-file-name "modules/lang/packages.el" user-emacs-directory))
(load (expand-file-name "modules/org/packages.el" user-emacs-directory))
(load (expand-file-name "modules/ui/packages.el" user-emacs-directory))
(mapc 'load (file-expand-wildcards (concat user-emacs-directory "themes/*/*.el")))

;; (add-hook 'after-init-hook #'(set-frame-font "Iosevka Comfy 10" nil t))

;; (profiler-stop)
(add-hook 'emacs-startup-hook (lambda ()
                                (when (get-buffer-window "*scratch*")
                                  (bury-buffer "*scratch*"))))
