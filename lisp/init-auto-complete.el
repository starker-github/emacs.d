(require-package 'auto-complete)
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)

;; 阻止自动触发补全动作
(setq-default ac-expand-on-auto-complete nil)
(setq-default ac-auto-start nil)
(setq-default ac-dwim nil) ; To get pop-ups with docs even if a word is uniquely completed

;; 用TAB作为手动触发补全动作的快捷键
;(ac-set-trigger-key "TAB")
(define-key ac-mode-map  [(tab)] 'auto-complete)

;;----------------------------------------------------------------------------
;; Use Emacs' built-in TAB completion hooks to trigger AC (Emacs >= 23.2)
;;----------------------------------------------------------------------------
;; 按下TAB时首先缩进所在行，然后尝试补全
(setq tab-always-indent 'complete)  ;; use 't when auto-complete is disabled
(add-to-list 'completion-styles 'initials t)
;; Stop completion-at-point from popping up completion buffers so eagerly
(setq completion-cycle-threshold 5)

;; TODO: find solution for php, haskell and other modes where TAB always does something

(setq c-tab-always-indent nil
      c-insert-tab-function 'indent-for-tab-command)

;; hook AC into completion-at-point
(defun sanityinc/auto-complete-at-point ()
  (when (and (not (minibufferp))
	     (fboundp 'auto-complete-mode)
	     auto-complete-mode)
    (auto-complete)))

(defun sanityinc/never-indent ()
  (set (make-local-variable 'indent-line-function) (lambda () 'noindent)))

(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions
        (cons 'sanityinc/auto-complete-at-point
              (remove 'sanityinc/auto-complete-at-point completion-at-point-functions))))

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)

(after-load 'init-yasnippet
  (set-default 'ac-sources
               '(ac-source-imenu
                 ac-source-abbrev
                 ac-source-dictionary
                 ac-source-words-in-buffer
                 ac-source-words-in-same-mode-buffers
                 ac-source-words-in-all-buffer
                 ac-source-functions
                 ac-source-yasnippet)))

(dolist (mode '(magit-log-edit-mode
                log-edit-mode org-mode text-mode haml-mode
                git-commit-mode
                sass-mode yaml-mode csv-mode espresso-mode haskell-mode
                html-mode nxml-mode sh-mode smarty-mode clojure-mode
                lisp-mode textile-mode markdown-mode tuareg-mode
                js3-mode css-mode less-css-mode sql-mode
                sql-interactive-mode
                inferior-emacs-lisp-mode))
  (add-to-list 'ac-modes mode))


;; Exclude very large buffers from dabbrev
(defun sanityinc/dabbrev-friend-buffer (other-buffer)
  (< (buffer-size other-buffer) (* 1 1024 1024)))

(setq dabbrev-friend-buffer-function 'sanityinc/dabbrev-friend-buffer)

;; 增强的popup列表
(require-package 'pos-tip)
(require 'pos-tip)
(setq ac-quick-help-prefer-pos-tip t)   ;default is t

;; 在弹出的popup中显示当前这个关键字的帮助
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 0.5)

;; 模糊匹配, 不能设置为t???
(setq ac-fuzzy-enable t)

(setq ac-trigger-commands
      (cons 'backward-delete-char-untabify ac-trigger-commands))

(add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
(add-hook 'auto-complete-mode-hook 'ac-common-setup)

;; c-headers
(require-package 'auto-complete-c-headers)
(defun my:ac-c-headers-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

(require 'init-yasnippet)
(require 'init-ac-source)

(provide 'init-auto-complete)
