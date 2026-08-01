;;; -*- lexical-binding: t -*-
(package! rustic
  :disabled t
  :mode "\\.rs\\'")

(package! rust-mode
  :mode "\\.rs\\'"
  :init
  (setq rust-mode-treesitter-derive t))

(package! cargo-mode
  :mode "\\.rs\\'"
  :hook
  (rust-ts-mode . cargo-minor-mode))
