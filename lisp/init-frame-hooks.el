;;----------------------------------------------------------------------------
;; after-make-frame-functions
;; 首先先明确下Emacs窗口的概念，我们双击Emacs图标打开程序见到的Windows窗口叫做Frame，
;; 包含了标题栏，菜单栏，工具栏，最下面的Mode Line和回显区域，而中间一大块显示文本的区
;; 域则是Window，实际上每个窗口都有自己的Mode Line。下文中我将称Frame为框，Window为窗
;; 口，这里和我们平时理解的Windows窗口有点区别。
;; after-make-frame-functions就是创建Frame后执行的hook，常和emacsclient配合使用
;; 留下备用。
;;----------------------------------------------------------------------------
;; after-init-hook
;; It is run after Emacs loads the init file, `default' library, the
;; abbrevs file, and additional Lisp packages (if any), and setting
;; the value of `after-init-time'.
;;----------------------------------------------------------------------------

(defvar after-make-console-frame-hooks '()
  "Hooks to run after creating a new TTY frame")
(defvar after-make-window-system-frame-hooks '()
  "Hooks to run after creating a new window-system frame")

(defun run-after-make-frame-hooks (frame)
  "Run configured hooks in response to the newly-created FRAME.
Selectively runs either `after-make-console-frame-hooks' or
`after-make-window-system-frame-hooks'"
  (with-selected-frame frame
    (run-hooks (if window-system
                   'after-make-window-system-frame-hooks
                 'after-make-console-frame-hooks))))

(add-hook 'after-make-frame-functions 'run-after-make-frame-hooks)

(defconst sanityinc/initial-frame (selected-frame)
  "The frame (if any) active during Emacs initialization.")

(add-hook 'after-init-hook
          (lambda () (when sanityinc/initial-frame
                  (run-after-make-frame-hooks sanityinc/initial-frame))))


(provide 'init-frame-hooks)
