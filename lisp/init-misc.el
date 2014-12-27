;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

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
(rename-buffer "work-shell")
(eshell)
(rename-buffer "tmp-shell")

(provide 'init-misc)
