(require-package 'markdown-mode)

(setq auto-mode-alist
      (cons '("\\.\\(md\\|markdown\\)\\'" . markdown-mode) auto-mode-alist))

(add-hook 'markdown-mode-hook (lambda ()
                                (setq tab-width 8) ;;8个缩进
                                ))

(provide 'init-markdown)
