(add-to-list 'load-path (concat user-emacs-directory "lib")) ;; where every config is stored

(global-display-line-numbers-mode 1)
(setq inhibit-startup-message t)
(display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(setq help-window-select t) 
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq org-directory "~/org/")


(require 'init-straight)

(require 'use-no-littering)

(require 'use-general)
(require 'use-base16-theme)
(require 'use-consult)
(require 'use-corfu)
(require 'use-evil)
(require 'use-lsp)
(require 'use-magit)
(require 'use-marginalia) ;; Enable rich annotations using the Marginalia package
(require 'use-savehist) ;; Persist history over Emacs restarts. Vertico sorts by history position.
(require 'use-vertico)
(require 'use-whichkey)
; (require 'use-minions) ;; might need if switching from doom-modeline
(require 'use-doom-modeline)
(require 'use-ghub)
(require 'use-dashboard)
(require 'use-projectile)

(require 'use-emacs)
