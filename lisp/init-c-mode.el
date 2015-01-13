;;------------------------- google c style -------------------------------------------
(require-package 'google-c-style)
(require 'google-c-style)
(add-hook 'c-mode-common-hook (lambda ()
                                (c-set-style "K&R")
                                (setq tab-width 4) ;;4个缩进
                                (setq indent-tabs-mode t)
                                (setq c-basic-offset 4)
                                (setq cscope-minor-mode t)
                                (fci-mode 1)))
(add-hook 'asm-mode-hook (lambda()
                                (setq cscope-minor-mode t)))
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;;------------------------- google code mode(space, 4 width, 4 c basic offset) -------------------------------------------
(defun google-code()
  (interactive)
  (princ "google coe mode: 4 tab-width 4 c-basic-offset")
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq c-basic-offset 4))
(global-set-key (kbd"C-c m g") 'google-code)
;;------------------------- c code mode(space, 4 width, 4 c basic offset) -------------------------------------------
(defun c-code()
  (interactive)
  (princ "c coe mode: 4 tab-width 4 c-basic-offset")
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (setq c-basic-offset 4))
(global-set-key (kbd"C-c m c") 'c-code)

(provide 'init-c-mode)
