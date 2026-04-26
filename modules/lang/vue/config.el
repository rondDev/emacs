;; -*- lexical-binding: t; -*-
(define-derived-mode vue-mode web-mode "Vue")
(rassq-delete-all 'vue-mode auto-mode-alist)
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))
;; (after! eglot
;;         (add-to-list 'eglot-server-programs
;;                      `(vue-mode . ,(lambda (&rest _)
;;                                      (let ((tsdk (expand-file-name
;;                                                   "node_modules/typescript/lib"
;;                                                   (or (locate-dominating-file default-directory "node_modules")
;;                                                       default-directory))))
;;                                        `("vue-language-server" "--stdio"
;;                                          :initializationOptions
;;                                          (:typescript (:tsdk ,tsdk)
;;                                                       :vue (:hybridMode :json-false)))))))
;;         (add-hook 'vue-mode-hook #'eglot-ensure)
;;         (advice-add 'eglot--glob-compile :around
;;                     (lambda (orig pattern &rest args)
;;                       (condition-case nil
;;                           (apply orig pattern args)
;;                         (error (lambda (_) nil))))
;;                     '((name . eglot--glob-compile-ignore-errors))))

(after! eglot
        (add-to-list 'eglot-server-programs
                     '(vue-mode . ("rass" "vuelang"))))
