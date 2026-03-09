;;; -*- lexical-binding: t -*-
(package! eglot
  :ensure nil
  :hook ((rust-ts-mode . eglot-ensure)))
(package! rustic
  :disabled t
  :mode "\\.rs\\'")

(package! cargo
  :hook (rust-ts-mode))
