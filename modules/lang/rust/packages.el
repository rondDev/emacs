;;; -*- lexical-binding: t -*-
(package! rustic
  :disabled t
  :mode "\\.rs\\'")

(package! rust-mode
  :init
  (setq rust-mode-treesitter-derive t))

(package! cargo-mode
  :hook
  (rust-ts-mode . cargo-minor-mode))
