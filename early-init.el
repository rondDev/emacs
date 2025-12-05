;;; -*- lexical-binding: t -*-
;; improves startup speed when using an alternative package manager
(add-to-list 'initial-frame-alist '(background-color . "#000000")) ; Or any other color

(setq package-enable-at-startup nil)
;; (setq inhibit-default-init nil)
(setq native-comp-async-report-warnings-errors nil) ; disable the pesky native comp warnings


(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq server-client-instructions nil)
(setq frame-inhibit-implied-resize t)

(advice-add #'x-apply-session-resources :override #'ignore)

;; ** Disable Tool Bar, Menu Bar, and Scroll Bar
;; doing this here reduces init time by ~0.2 seconds for me
;; disabling `tool-bar-mode' in normal init file takes ~0.1s
;; https://github.com/raxod502/radian/issues/180
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)


(let ((gap (or (getenv "WM_GAP") "15")))
  (push (cons 'internal-border-width (string-to-number gap)) default-frame-alist))

;; unfortunately Emacs has no way to exclude text from being transparent
;; active and inactive alpha
(unless (string= (getenv "XDG_SESSION_TYPE") "wayland")
  (push '(alpha . (100 . 100)) default-frame-alist))
;; no titlebar
;; added in a patch; see my emacs.nix overlay
(when (eq system-type 'darwin)
  (push '(undecorated-round . t) default-frame-alist))

;; * Prevent Default Mode Line from Showing
;; https://github.com/hlissner/doom-emacs/blob/7460e9e7989c9b219879073690e6f43ac535d274/modules/ui/modeline/config.el#L16
;; doesn't actually need to be set this early but it still makes sense to put it
;; here
;; TODO: uncomment
(unless after-init-time
  ;;prevent flash of unstyled modeline at startup
  (setq-default mode-line-format nil))

;; * Silence lexical binding warning
;; don't show warning buffer for; tons of packages are missing it
(setq warning-suppress-types '((files)))
