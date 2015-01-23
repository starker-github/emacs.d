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
(require 'init-hippie-expand)
(require 'init-auto-complete)
(require 'init-editing-utils)
(require 'init-hs-minor-mode)
(require 'init-bookmarks)
(require 'jumplist)

(require 'init-cscope)

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
