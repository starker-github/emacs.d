
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(if (boundp 'server-base)
    (add-to-list 'load-path (expand-file-name "lisp" server-base))
  (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory)))
(require 'init-benchmarking) ;; Measure startup time，init-session中会用到

;;----------------------------------------------------------------------------
;; Function Select
;;----------------------------------------------------------------------------
(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(require 'init-utils)
(require 'init-elpa) ;; Machinery for installing required packages

;;----------------------------------------------------------------------------
;; require package
;;----------------------------------------------------------------------------
;; 可以在*grep*直接编辑buffer
;; (require-package 'wgrep)
;; 记录所有的操作. To start it, call mwe:log-keyboard-commands. Then, call mwe:open-command-log-buffer.
;; (require-package 'mwe-log-commands)
;; shorten or erase modeline presence of minor modes; 缩短或擦除modeline
(require-package 'diminish)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

;;;;;; frame ;;;;;;
(require 'init-frame-hooks)
(require 'init-themes)
(require 'init-gui-frames)
(require 'init-fonts)

;; 终端下使用emacs组合键
;; (require 'init-xterm)

;;;;;; utils ;;;;;;
(require 'init-isearch)
(require 'init-grep)
(require 'init-ido)
(if (not (boundp 'server-base))
    (progn
      (require 'init-recentf)
      (require 'init-sessions)))

;;;;;; buffer/windows ;;;;;;
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-windows)

;;;;;; editing ;;;;;;
;; (require 'init-flycheck)
(require 'init-company-mode)
;(require 'init-hippie-expand)
;(require 'init-auto-complete)
(require 'init-editing-utils)
(require 'init-hs-minor-mode)
(require 'init-bookmarks)
(require 'jumplist)

(require 'init-cscope)
(require 'init-compile)

(require 'init-c-mode)
(require 'init-markdown)
(require 'init-python-mode)

;;;;;; lisp ;;;;;;
;; (require 'init-paredit)
;; (require 'init-lisp)
;; (require 'init-slime)
;; (require 'init-common-lisp)

(require 'init-misc)

;; 正则表达式测试工具
(require-package 'regex-tool)

(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-irony-c-headers company-irony irony-eldoc irony company-quickhelp company-math ycmd yasnippet xcscope window-numbering whole-line-or-region whitespace-cleanup-mode wgrep-ag unfill undo-tree switch-window smex shell-pop session regex-tool pos-tip popup-switcher popup-imenu pip-requirements page-break-lines multiple-cursors move-dup math-symbol-lists markdown-mode indent-guide idomenu ido-ubiquitous ibuffer-vc highlight-symbol highlight-escape-sequences guide-key google-c-style fullframe flycheck fill-column-indicator f expand-region diminish company cmake-mode browse-kill-ring auto-complete-c-headers anzu ag ace-jump-mode)))
 '(shell-pop-full-span t)
 '(shell-pop-shell-type
   (quote
    ("eshell" "*eshell*"
     (lambda nil
       (eshell shell-pop-term-shell)))))
 '(shell-pop-term-shell "/bin/bash")
 '(shell-pop-universal-key "C-x p")
 '(shell-pop-window-position "bottom")
 '(shell-pop-window-size 20))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-preview ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-scrollbar-bg ((t (:background "darkgray" :foreground "black"))))
 '(company-scrollbar-fg ((t (:background "gray35"))))
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold)) (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:inherit company-tooltip-selection))))
 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white")))))
