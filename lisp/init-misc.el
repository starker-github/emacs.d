;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

(require-package 'sr-speedbar)
(require 'sr-speedbar)
;; 左侧显示
(setq sr-speedbar-right-side nil)
;; 设置宽度
(setq sr-speedbar-width 25)
;(global-set-key (kbd "C-<tab>") 'sr-speedbar-toggle)
;; 不显示图标
(setq speedbar-use-images nil)
;; 自动刷新
(setq sr-speedbar-auto-refresh t)
;; inhibit tags grouping and sorting
(setq speedbar-tag-hierarchy-method '(speedbar-simple-group-tag-hierarchy) )

(require'imenu-list)
(global-set-key (kbd "C-<tab>") 'imenu-list-minor-mode)
(setq imenu-list-focus-after-activation t)
(setq imenu-list-auto-resize t)
(setq imenu-list-position 'left)

;; 
(require 'iimage)

(add-hook 'info-mode-hook 'iimage-mode)
(add-hook 'markdown-mode-hook '(lambda()
               (define-key markdown-mode-map
                 (kbd "<f5>") 'turn-on-iimage-mode)))

(setq iimage-mode-image-search-path '(list "." "images/"))

;; for octopress
(add-to-list 'iimage-mode-image-regex-alist ; match: {% img xxx %}
       (cons (concat "{% img /?\\("
             iimage-mode-image-filename-regex
             "\\) %}") 1))
(add-to-list 'iimage-mode-image-regex-alist ; match: ![xxx](/xxx)
       (cons (concat "!\\[.*?\\](/\\("
             iimage-mode-image-filename-regex
             "\\))") 1))
;; 兼容以前在wordpress添加的图片
(add-to-list 'iimage-mode-image-regex-alist ; match: ![xxx](http://everet.org/xxx)
       (cons (concat "!\\[.*?\\](http://everet.org/\\(wp-content/"
             iimage-mode-image-filename-regex
             "\\))") 1))
;; 

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
(rename-buffer "tmp-shell")
(eshell)
(rename-buffer "work-shell")

(defun pwd-to-clipboard ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (kill-new (buffer-file-name))
  (message (buffer-file-name)))

(defun kid-switch-to-shell ()
  (interactive)
  (let ((file buffer-file-name))
    (select-window (display-buffer (get-buffer "current-shell")))
    (when file
      (end-of-buffer)
        (insert "cd " (file-name-directory file))
        (call-interactively-p 'comint-send-input))))

(require-package 'shell-pop)
(require 'shell-pop)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
 '(shell-pop-shell-type (quote ("eshell" "*eshell*" (lambda nil (eshell shell-pop-term-shell)))))
 '(shell-pop-term-shell "/bin/bash")
 '(shell-pop-universal-key "C-x p")
 '(shell-pop-window-size 20)
 '(shell-pop-full-span t)
 '(shell-pop-window-position "bottom"))

(require-package 'flycheck)
(require 'flycheck)
(global-flycheck-mode)

(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))

(defadvice align-regexp (around align-regexp-with-spaces activate)
  (let ((indent-tabs-mode nil))
    ad-do-it))

(provide 'init-misc)
