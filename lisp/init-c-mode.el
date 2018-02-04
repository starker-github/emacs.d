;;------------------------- google c style -------------------------------------------
(require-package 'google-c-style)
(require 'google-c-style)
;;------------------------- k&R code mode --------------------------------------------
(defun c-k&r-hook()
  (interactive)
  (c-set-style "K&R")
  (setq tab-width 8) ;;8个缩进
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8)
  (setq cscope-minor-mode t)
  (fci-mode 1))
;;------------------------- my c++ mode -------------------------------------------------
(defun my-c++-mode-hook()
  (interactive)
  (google-set-c-style)
  (setq tab-width 4 indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (setq cscope-minor-mode t)
  (c-set-offset 'case-label 0)
  (c-set-offset 'topmost-intro-cont 0 nil)
  (fci-mode 1))
;;------------------------- my google mode -------------------------------------------------
(defun my-google-c-mode-hook()
  (interactive)
  (google-set-c-style)
  (setq cscope-minor-mode t)
  (fci-mode 1))
(setq-default indent-tabs-mode nil)
;;------------------------- c/c++ mode -----------------------------------------------
(add-hook 'asm-mode-hook (lambda()
                                (setq cscope-minor-mode t)))
(add-hook 'makefile-mode-hook (lambda()
                                (setq cscope-minor-mode t)))
;(add-hook 'c++-mode-hook 'my-c++-mode-hook)
;(add-hook 'c++-mode-hook 'my-google-c-mode-hook)
(add-hook 'c-mode-hook 'c-k&r-hook)
(add-hook 'c-mode-common-hook 'my-google-c-mode-hook)
;(add-hook 'c-mode-common-hook 'my-c++-mode-hook)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))

(global-set-key (kbd"C-c m c") 'c-k&r-hook)
(global-set-key (kbd"C-c m m") 'my-c++-mode-hook)

;;------------------------- makefile mode -------------------------------------------
(setq auto-mode-alist (cons '(".*\\.mak$" .
                              makefile-mode) auto-mode-alist))

;;------------------------- kconfig mode -------------------------------------------
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
