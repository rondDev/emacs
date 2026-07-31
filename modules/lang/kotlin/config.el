(add-to-list 'interpreter-mode-alist '("kscript" . kotlin-mode))
;; (setenv "JDK_JAVA_OPTIONS" "--sun-misc-unsafe-memory-access=allow")

(after! eglot
  ;; Reset any conflicting arguments and apply backwards-compatible JVM parameters
  ;; (setq eglot-connect-timeout 120)
  (add-to-list 'eglot-server-programs
               '(kotlin-mode . ("env"
                                "JDK_JAVA_OPTIONS=--add-opens=java.base/java.lang=ALL-UNNAMED" 
                                "kotlin-language-server"))))

