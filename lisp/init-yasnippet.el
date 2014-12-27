;; yasnippet
(require-package 'yasnippet)
(require 'yasnippet)
;; 使用Ctrl-c k作为唯一的触发快捷键
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)
(yas-global-mode t)

(provide 'init-yasnippet)
