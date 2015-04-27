;;------------------------- google c style -------------------------------------------
(require-package 'google-c-style)
(require 'google-c-style)
(add-hook 'c-mode-common-hook (lambda ()
                                (c-set-style "K&R")
                                (setq tab-width 8) ;;8个缩进
                                (setq indent-tabs-mode t)
                                (setq c-basic-offset 8)
                                (setq cscope-minor-mode t)
                                (fci-mode 1)))
(add-hook 'asm-mode-hook (lambda()
                                (setq cscope-minor-mode t)))
(add-hook 'makefile-mode-hook (lambda()
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

;;; kconfig.el - a major mode for editing linux kernel config (Kconfig) files
;; Copyright © 2014 Yu Peng
;; Copyright © 2014 Michal Sojka
(defvar kconfig-mode-font-lock-keywords
  '(("^[\t, ]*\\_<bool\\_>" . font-lock-type-face)
    ("^[\t, ]*\\_<int\\_>" . font-lock-type-face)
    ("^[\t, ]*\\_<boolean\\_>" . font-lock-type-face)
    ("^[\t, ]*\\_<tristate\\_>" . font-lock-type-face)
    ("^[\t, ]*\\_<depends on\\_>" . font-lock-variable-name-face)
    ("^[\t, ]*\\_<select\\_>" . font-lock-variable-name-face)
    ("^[\t, ]*\\_<help\\_>" . font-lock-variable-name-face)
    ("^[\t, ]*\\_<---help---\\_>" . font-lock-variable-name-face)
    ("^[\t, ]*\\_<default\\_>" . font-lock-variable-name-face)
    ("^[\t, ]*\\_<range\\_>" . font-lock-variable-name-face)
    ("^\\_<config\\_>" . font-lock-constant-face)
    ("^\\_<comment\\_>" . font-lock-constant-face)
    ("^\\_<menu\\_>" . font-lock-constant-face)
    ("^\\_<endmenu\\_>" . font-lock-constant-face)
    ("^\\_<if\\_>" . font-lock-constant-face)
    ("^\\_<endif\\_>" . font-lock-constant-face)
    ("^\\_<menuconfig\\_>" . font-lock-constant-face)
    ("^\\_<source\\_>" . font-lock-keyword-face)
    ("\#.*" . font-lock-comment-face)
    ("\".*\"$" . font-lock-string-face)))

(defvar kconfig-headings
  '("bool" "int" "boolean" "tristate" "depends on" "select"
    "help" "---help---" "default" "range" "config" "comment"
    "menu" "endmenu" "if" "endif" "menuconfig" "source"))

(defun kconfig-outline-level ()
  (looking-at "[\t ]*")
  (let ((prefix (match-string 0))
	(result 0))
    (dotimes (i (length prefix) result)
      (setq result (+ result
		      (if (equal (elt prefix i) ?\s)
			  1 tab-width))))))

(define-derived-mode kconfig-mode text-mode
  "kconfig"
  (set (make-local-variable 'font-lock-defaults)
       '(kconfig-mode-font-lock-keywords t))
  (set (make-local-variable 'outline-regexp)
       (concat "^[\t ]*" (regexp-opt kconfig-headings)))
  (set (make-local-variable 'outline-level)
       'kconfig-outline-level))

(add-to-list 'auto-mode-alist '("Kconfig" . kconfig-mode))

(add-hook 'kconfig-mode-hook (lambda()
                                (setq cscope-minor-mode t)))
(add-hook 'conf-unix-mode-hook (lambda()
                                (setq cscope-minor-mode t)))

(provide 'init-c-mode)
