;;; hide-show
(setq hs-allow-nesting t)

(add-hook 'c-mode-common-hook
          (lambda ()
            (hs-minor-mode 1)
            ))

(add-hook 'emacs-lisp-mode-hook
          (lambda()
            (hs-minor-mode 1)))

(add-hook 'tcl-mode-hook (lambda ()
                           (hs-minor-mode 1)
                           ))

(define-key global-map [f7] 'hs-toggle-hiding)
(define-key global-map [f8] 'hs-show-all)

;;; hide ifdef
(defun my-hif-toggle-block ()
  "toggle hide/show-ifdef-block --lgfang"
  (interactive)
  (require 'hideif)
  (let* ((top-bottom (hif-find-ifdef-block))
         (top (car top-bottom)))
    (goto-char top)
    (hif-end-of-line)
    (setq top (point))
    (if (hif-overlay-at top)
        (show-ifdef-block)
      (hide-ifdef-block))))

(defun hif-overlay-at (position)
  "An imitation of the one in hide-show --lgfang"
  (let ((overlays (overlays-at position))
        ov found)
    (while (and (not found) (setq ov (car overlays)))
      (setq found (eq (overlay-get ov 'invisible) 'hide-ifdef)
            overlays (cdr overlays)))
    found))

(add-hook 'c-mode-hook 'hide-ifdef-mode)
(define-key global-map [f9]  'my-hif-toggle-block)
(define-key global-map [f10] 'show-ifdefs)

(provide 'init-hs-minor-mode)
