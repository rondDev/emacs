;; -*- lexical-binding: t; -*-
(defvar rond/config-files
  (list
   "~/.emacs-profiles.el"
   "~/.zshrc"
   "~/.config/hypr/hyprland.conf"
   "~/.config/neovim/init.lua"))

;; NOTE: Ensures it has a timestamp because nil will always be less
(defun rond//file-modification-time (f)
  (or (file-attribute-modification-time (file-attributes f)) '(0 0)))

;; NOTE: I feel like this is really ugly, but idk a better way to do it
(defun rond/find-config-file ()
  "Function to find config files for easy editing"
  (interactive)
  (find-file
   (consult--read
    (sort
     rond/config-files
     (lambda (a b)
       (time-less-p (rond//file-modification-time b) (rond//file-modification-time a))))
    
    :prompt "Config file: " :sort nil :category 'file)))

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
