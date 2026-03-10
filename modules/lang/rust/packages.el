;;; -*- lexical-binding: t -*-
(package! rustic
  :disabled t
  :mode "\\.rs\\'")

(package! cargo-mode
  :hook
  (rust-ts-mode . cargo-minor-mode))
