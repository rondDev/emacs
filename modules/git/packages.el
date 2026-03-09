;;; -*- lexical-binding: t -*-
(package! forge
  :after magit
  :init (setq forge-add-default-bindings nil))

(package! ghub
  :after magit)

(package! magit
  :defer t
  :after general)

(package! tramp
  :ensure nil
  :defer t)
