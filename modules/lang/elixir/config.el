;; -*- lexical-binding: t; -*-
(add-hook! 'emacs-startup-hook
  (rassq-delete-all 'heex-ts-mode auto-mode-alist)
  (add-to-list 'auto-mode-alist '("\\.[hl]?eex\\'" . elixir-ts-mode)))
