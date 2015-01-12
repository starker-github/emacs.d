(add-to-list 'load-path (expand-file-name "lisp/custom-themes" user-emacs-directory))

;;------------------------------------------------------------------------------
;; monokai-theme
;;------------------------------------------------------------------------------
;;(require-package 'monokai-theme)
;;(load-theme 'monokai t)
;;(set-background-color "#192022")

;;------------------------------------------------------------------------------
;; color-theme-tomorrow
;;------------------------------------------------------------------------------
;; (require-package 'color-theme)
;; (require 'color-theme)
;; (load "~/.emacs.d/lisp/custom-themes/color-theme-tomorrow.el")
;; (eval-after-load "color-theme"
;;   '(progn
;;       (color-theme-tomorrow-night)))
;; (require 'color-theme-tomorrow)

;;------------------------------------------------------------------------------
;; color-theme-wombat
;;------------------------------------------------------------------------------
;(load "~/.emacs.d/lisp/custom-themes/color-theme-wombat.el")
;(require 'color-theme-wombat)
;(load-theme 'wombat)

;;------------------------------------------------------------------------------
;; desert-theme
;;------------------------------------------------------------------------------
;(load "~/.emacs.d/lisp/custom-themes/desert-theme.el")
;(require 'desert-theme)

;;------------------------------------------------------------------------------
;; darcula-theme
;;------------------------------------------------------------------------------
;(load "~/.emacs.d/lisp/custom-themes/darcula-theme.el")
;(require 'darcula-theme)

;;------------------------------------------------------------------------------
;; sanityinc-tomorrow-eighties
;;------------------------------------------------------------------------------
(add-to-list 'load-path (expand-file-name "lisp/custom-themes/color-theme-sanityinc-tomorrow/" user-emacs-directory))
(load "~/.emacs.d/lisp/custom-themes/color-theme-sanityinc-tomorrow/sanityinc-tomorrow-eighties-theme.el")
(require 'sanityinc-tomorrow-eighties-theme)

(setq-default line-spacing 2)
(set-face-background 'region "SteelBlue4")

(provide 'init-themes)
