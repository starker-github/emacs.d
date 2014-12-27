;;------------------------------------------------------------------------------
;; monokai-theme
;;------------------------------------------------------------------------------
(require-package 'monokai-theme)
(load-theme 'monokai t)
(set-background-color "#192022")
(set-face-background 'region "SteelBlue4")

;;------------------------------------------------------------------------------
;; color-theme-tomorrow
;;------------------------------------------------------------------------------
;; (add-to-list 'load-path (expand-file-name "lisp/custom-themes" user-emacs-directory))
;; (require-package 'color-theme)
;; (require 'color-theme)
;; (load "~/.emacs.d/lisp/custom-themes/color-theme-tomorrow.el")
;; (eval-after-load "color-theme"
;;   '(progn
;;       (color-theme-tomorrow-night)))
;; (require 'color-theme-tomorrow)

(provide 'init-themes)
