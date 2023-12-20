;; Don't show the splash screen
(setq inhibit-startup-message t)  ; Comment at end of line!

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

(defun rond/load(filepath)
  (load (expand-file-name
          (concat user-emacs-directory filepath))))



;; should only be used if init is longer than 3 lines
(defun rond/initfile(name)
  (rond/load (concat "init/" name)))

;; should only be used if config is longer than 3 lines
(defun rond/configfile(name)
  (rond/load (concat "config/" name)))



(use-package general
             :straight t
             :config
             (rond/configfile "general"))


(use-package evil
             :general
             (rond/leader-keys
               "w" '(:keymap evil-window-map :wk "window"))
             :straight t
             :config
             (rond/configfile "evil"))
