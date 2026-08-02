;; -*- lexical-binding: t; -*-
(package! kotlin-mode
 :hook
  (kotlin-mode . eglot-ensure))
