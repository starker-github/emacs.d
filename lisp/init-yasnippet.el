;; yasnippet
(require-package 'yasnippet)
;(add-to-list 'load-path (expand-file-name "lisp/yasnippet" user-emacs-directory))
;(add-to-list 'load-path "~/.emacs.d/lisp/yasnippet")
(require 'yasnippet)
;; 使用shift+TAB作为唯一的触发快捷键
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)
(yas-global-mode t)

(provide 'init-yasnippet)
