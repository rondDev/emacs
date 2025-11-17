(defmacro after! (package &rest body)
   `(with-eval-after-load ',package ,@body))

(defmacro s-map! (&rest body)
  "Safe mapping for keybinds"
   `(after! general (general-define-key ,@body)))

(defalias 'package! 'use-package)
