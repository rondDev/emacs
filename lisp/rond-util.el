;;;###autoload
(defmacro after! (package &rest body)
   `(with-eval-after-load ',package ,@body))

;;;###autoload
(defmacro s-map! (&rest body)
  "Safe mapping for keybinds"
   `(after! general (general-define-key ,@body)))

;;;###autoload
(defalias 'package! 'use-package)

(provide 'rond/util)
