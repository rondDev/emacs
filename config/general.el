(general-evil-setup)

(general-create-definer rond/leader-keys
                        :states '(normal insert visual emacs)
                        :keymaps 'override
                        :prefix "SPC" ; set leader
                        :global-prefix "M-SPC") ; leader in insert mode

(general-create-definer rond/local-leader-keys
                        :states '(normal insert visual emacs)
                        :keymaps 'override
                        :prefix "SPC" ; set local leader
                        :global-prefix "M-SPC") ; local leader in insert mode


(rond/leader-keys
  "SPC" '(execute-extended-command :wk "basically M-x"))


;; TODO: possibly come back to this, not sure I want SPC-f for files
(rond/leader-keys
  "f" '(:ignore t :wk "file")
  "ff" '(find-file :wk "find file")
  "fs" '(save-buffer :wk "save file"))
