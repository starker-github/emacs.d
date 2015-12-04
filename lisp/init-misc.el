;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;(require-package 'sr-speedbar)
(require 'sr-speedbar)
;; 左侧显示
(setq sr-speedbar-right-side nil)
;; 设置宽度
(setq sr-speedbar-width 25)
(global-set-key (kbd "C-<tab>") 'sr-speedbar-toggle)
;; 不显示图标
(setq speedbar-use-images nil)
;; 自动刷新
(setq sr-speedbar-auto-refresh t)
;; inhibit tags grouping and sorting
(setq speedbar-tag-hierarchy-method '(speedbar-simple-group-tag-hierarchy) )

;; **************************************************************************
;;; ***** built-in functions
;;; **************************************************************************
(defun eshell/clear () ;;clear可换其他名称
  "Clears the shell buffer ala Unix's clear or DOS' cls"
  (interactive)
  ;; the shell prompts are read-only, so clear that for the duration
  (let ((inhibit-read-only t))
        ;; simply delete the region
        (delete-region (point-min) (point-max))))

;;; **************************************************************************
;;; ******* remove M^
;;; **************************************************************************
(defun dos-unix () (interactive)
   (goto-char (point-min))
   (while (search-forward "\r" nil t) (replace-match "")))
(defun unix-dos () (interactive)
   (goto-char (point-min))
   (while (search-forward "\n" nil t) (replace-match "\r\n")))

;; shell
(defun eshell-scroll-conservatively ()
"Add to shell-mode-hook to prevent jump-scrolling on newlines in shell buffers."
(make-local-variable 'scroll-margin)
(setq scroll-margin 0))
(add-hook 'eshell-mode-hook 'eshell-scroll-conservatively)
(eshell)
(rename-buffer "aaaa-shell")
(eshell)
(rename-buffer "bbbb-shell")
(eshell)
(rename-buffer "cccc-shell")
(eshell)
(rename-buffer "dddd-shell")
(eshell)
(rename-buffer "note-shell")
(eshell)
(rename-buffer "tmp-shell")
(eshell)
(rename-buffer "work-shell")

(provide 'init-misc)
