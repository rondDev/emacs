;;; -*- lexical-binding: t -*-
(package! eglot
  :ensure nil
  :hook ((rust-ts-mode . eglot-ensure)))
(package! rustic
  :disabled t
  :mode "\\.rs\\'"
  :config
  ;; TODO: Add more
  (comma-def!
    :states '(normal visual motion)
    :prefix "r"
    "a" '(rustic-cargo-add :wk "cargo add")
    "b" '(rustic-cargo-build :wk "cargo build")
    "B" '(rustic-cargo-bench :wk "cargo bench")
    "d" '(rustic-cargo-doc :wk "cargo doc")
    "i" '(rustic-cargo-init :wk "cargo init")
    "n" '(rustic-cargo-new :wk "cargo new")
    "r" '(rustic-cargo-run :wk "cargo run")
    "t" '(rustic-cargo-test :wk "cargo test")
    "x" '(rustic-cargo-rm :wk "cargo rm"))
  (setq rustic-lsp-client 'eglot)
  (add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1))))

(package! cargo
  :config
  (add-hook 'rust-mode-hook 'cargo-minor-mode))
