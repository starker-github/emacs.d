;; (require-package 'auto-complete-clang)
;; (require 'auto-complete-clang)

;; (defun my-ac-cc-mode-setup ()
;;   (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
;; (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;; (add-hook 'c++-mode-hook 'my-ac-cc-mode-setup)

(setenv "LD_LIBRARY_PATH" "/usr/lib/llvm-3.5/lib/")
(require 'auto-complete-clang-async)
(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
  (setq ac-sources (append '(ac-source-clang-async ac-source-yasnippet) ac-sources))
;  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process)
  )
(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'c++-mode-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(my-ac-config)

;; echo "" | g++ -v -x c++ -E -
(setq ac-clang-flags
      (mapcar (lambda (item) (concat "-I" item))
              (split-string
               " /usr/include/c++/4.8
                 /usr/include/x86_64-linux-gnu/c++/4.8
                 /usr/include/c++/4.8/backward
                 /usr/lib/gcc/x86_64-linux-gnu/4.8/include
                 /usr/local/include
                 /usr/lib/gcc/x86_64-linux-gnu/4.8/include-fixed
                 /usr/include/x86_64-linux-gnu
                 /usr/include
                ")))

(provide 'init-ac-source)
