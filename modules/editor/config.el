;; -*- lexical-binding: t; -*-
(defvar rond/config-files
  (list
   "~/.emacs-profiles.el"
   "~/.zshrc"
   "~/.config/hypr/hyprland.conf"
   "~/.config/neovim/init.lua"))

;; NOTE: Ensures it has a timestamp because nil will always be less
(defun rond//file-mod-time (f)
  (or (file-attribute-modification-time (file-attributes f)) '(0 0)))

;; NOTE: I feel like this is really ugly, but idk a better way to do it
;; (defun rond/find-config-file ()
;;   "Function to find config files for easy editing"
;;   (interactive)
;;   (find-file
;;    (consult--read
;;     (sort
;;       (split-string (string-trim (shell-command-to-string "fd .  ~/.config/home-manager/config/ -d 1 -t d")))
;;      (lambda (a b)
;;        (time-less-p (rond//file-mod-time b) (rond//file-mod-time a))))

;;     :prompt "Config file: " :sort nil :category 'file)))



(defun rond/find-config-file ()
  (interactive)
  (let* ((base-dir (expand-file-name "~/.config/home-manager/config/"))
         (candidates
          (mapcar (lambda (path)
                    (let* ((short (file-name-as-directory (file-name-nondirectory (directory-file-name path))))
                           (padded-display (truncate-string-to-width short 25 nil ?\s)))
                      (propertize short 'display padded-display)))
           (sort (directory-files base-dir t "^[^.]" t)
                 (lambda (a b)
                   (time-less-p (rond//file-mod-time b)
                                (rond//file-mod-time a)))))))

    (minibuffer-with-setup-hook
        (lambda () (setq default-directory base-dir))

      (let ((selection (consult--read
                        candidates
                        :prompt "Config file: "
                        :sort nil
                        :category 'file
                        :annotate (lambda (cand)
                                    (marginalia-annotate-file cand)))))

        (find-file (expand-file-name selection base-dir))))))

(after! evil-multiedit
        (evil-multiedit-default-keybinds))

(after! visual-regexp-steroids
        (defun rond/select-vr-replace ()
          (interactive)
          (evil-visual-select (point-min) (point-max))
          (call-interactively 'vr/replace))
        (def!
          :states '(normal visual motion)
          "C-%" 'rond/select-vr-replace))
