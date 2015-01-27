(require-package 'xcscope)
(after-load 'windows
  (require 'xcscope))

(defun cscope-display-layout (win)
  "layout of cscope list"
  ;; (message "---- cscope-display-layout win: %s" win)
  (select-window win)
  (delete-other-windows)
  ;; (message "  -- cscope-display-layout window-1: %s" (selected-window))
  (split-window-horizontally)
  (other-window 1)
  ;; (message "  -- cscope-display-layout window-2: %s" (selected-window))
  (setq cscope-special-window (selected-window))
  (split-window-vertically)
  (other-window 1)
  ;; (message "  -- cscope-display-layout window-3: %s" (selected-window))
  (selected-window))

(defun cscope-window-window (win)
  (get-buffer-window (window-buffer cscope-marker-window)))

(defvar cscope-resume-ring-length 16
  "Length of the cscope resume ring.")

(defvar cscope-resume-ring (make-ring cscope-marker-ring-length)
  "Ring of resumes which are locations from which cscope was invoked.")

(defun cscope-pop-resume()
  "Pop back to window when cscope was last invoked."
  (if (ring-empty-p cscope-resume-ring)
      (error "There are no resume list in the cscope-resume-ring yet"))
  (let ((list (ring-remove cscope-resume-ring 0)))
    ;; (message "######## cscope-pop-resume: list: %s" list)
    (if (and (listp list) (window-configuration-p (car list)) (markerp (nth 1 list)))
        (progn
          ;; (message "    #### cscope-pop-resume: window-configuration is %s" (nth 0 list))
          ;; (message "    #### cscope-pop-resume: marker is %s" (nth 1 list))
          (set-window-configuration (nth 0 list))
          (goto-char (nth 1 list)))
      (error "cscope-pop-resume: argrument is error!!!"))))

(defun cscope-resume ()
  "resume where cscope was last invoked."
  (interactive)
  (cscope-pop-resume)
  )

;; 修改cscope的显示方式
;; (add-to-list 'special-display-regexps '("*cscope*" cscope-display-buffers))
;; (defun cscope-display-buffers (buf)
;;   "display cscope in special window"
;;   (delete-other-windows)
;;   (split-window-horizontally)
;;   (other-window 1)
;;   (message "cscope-special-window: %s" (selected-window))
;;   (setq cscope-special-window (selected-window))
;;   (split-window-vertically)
;;   (other-window 1)
;;   (set-window-buffer (selected-window) buf)
;;   (selected-window))

;; fix cscope keymap
(let ((map cscope-list-entry-keymap))
  (define-key map "r" 'cscope-pop-mark)
  (define-key map "u" 'cscope-resume)
  (setq cscope-list-entry-keymap map))
(let ((map cscope-minor-mode-keymap))
  (define-key map "\C-csr" 'cscope-pop-mark)
  (define-key map "\C-csu" 'cscope-resume)
  (setq cscope-minor-mode-keymap map))

;; fix cscope function
(defun cscope-call (basemsg search-id symbol)
  "Generic function to call to process cscope requests.
BASEMSG is a message describing this search; SEARCH-ID is a
numeric id indicating to the cscope backend what kind of search
this is."
  (let* ( (outbuf (get-buffer-create cscope-output-buffer-name))
          (old-buffer (current-buffer))
          (directory
           (cscope-canonicalize-directory

            ;; if we have an initial directory, use it. Otherwise if we're in
            ;; *cscope*, try to use the directory of the search at point
            (or cscope-initial-directory
                (and (eq outbuf old-buffer)
                     (get-text-property (point) 'cscope-directory)))))
          (msg (concat basemsg " "
                       (cscope-boldify-if-needed symbol)))
          (args (list (format "-%d" search-id) symbol)))
    (if cscope-process
        (error "A cscope search is still in progress -- only one at a time is allowed"))
    (if (eq outbuf old-buffer) ;; In the *cscope* buffer.
        (let ((marker-buf (window-buffer cscope-marker-window)))
          (when marker-buf
              ;; Assume that cscope-marker-window is the window, from the
              ;; users perspective, from which the search was launched and the
              ;; window that should be returned to upon cscope-pop-mark.
            (with-current-buffer marker-buf
              (setq cscope-marker (point-marker)))))

      ;; Not in the *cscope buffer.
          ;; Set the cscope-marker-window to whichever window this search
          ;; was launched from.
      (setq cscope-marker-window (get-buffer-window old-buffer))
      (setq cscope-marker (point-marker)))
    ;; (message "========> cscope-call: cscope-marker-window - %s" cscope-marker-window)
    (ring-insert cscope-resume-ring (list (current-window-configuration) (point-marker)))
    ;; (message "******** %s" 'cscop-resume-ring)
    (set-window-buffer (cscope-display-layout (cscope-window-window cscope-marker-window)) (get-buffer-create cscope-output-buffer-name))
    (with-current-buffer outbuf
      (if cscope-display-times
          (let ( (times (current-time)) )
            (setq cscope-start-time (+ (* (car times) 65536.0) (cadr times)
                                       (* (cadr (cdr times)) 1.0E-6)))))
      (setq default-directory directory
            cscope-start-directory nil
            cscope-search-list (cscope-find-info directory)
            cscope-searched-dirs nil
            cscope-command-args args
            cscope-first-match-point nil
            cscope-stop-at-first-match-dir-meta (memq t cscope-search-list)
            cscope-matched-multiple nil)
      (setq truncate-lines cscope-truncate-lines)

      ;; insert the separator at the start of the result set
      (unless (boundp 'cscope-rerunning-search) (goto-char (point-max)))
      (when (not (bolp))
        (insert "\n"))

      ;; don't apply the face to the trailing newline in the separator
      (let ((separator-start (point)))
        (insert cscope-result-separator)
        (when cscope-use-face
          (put-text-property separator-start (1- (point)) 'face 'cscope-separator-face)
          (put-text-property separator-start (1- (point)) 'cscope-stored-search cscope-previous-user-search)))

      (insert msg)
      (cscope-search-one-database))

    (if cscope-display-cscope-buffer
        (progn
          (pop-to-buffer outbuf)
          (cscope-help))
      (set-buffer outbuf))
    (cscope-list-entry-mode)
    ))

(defun cscope-show-entry-internal (navprops
                                   &optional save-mark-p window arrow-p)
  "Display the buffer corresponding to FILE and LINE-NUMBER
in some window.  If optional argument WINDOW is given,
display the buffer in that WINDOW instead.  The window is
not selected.  Save point on mark ring before goto
LINE-NUMBER if optional argument SAVE-MARK-P is non-nil.
Put `overlay-arrow-string' if arrow-p is non-nil.
Returns the window displaying BUFFER."
  (let ( (file                     (elt navprops 0))
         (line-number              (or (elt navprops 1) -1))
         (fuzzy-search-text-regexp (elt navprops 2))
         buffer old-pos old-point new-point forward-point backward-point
         line-end line-length)
    (if (not (windowp window))
        (progn
          ;; (message "========> cscope-show-entry-internal: nil(%s)" cscope-special-window)
          (setq window cscope-special-window))
      ;; (message "========> cscope-show-entry-internal: %s" window)
      )
    (if (and (stringp file)
             (integerp line-number))
        (progn
          (unless (file-readable-p file)
            (error "%s is not readable or exists" file))
          (setq buffer (find-file-noselect file))
          (if (windowp window)
              (set-window-buffer window buffer)
            (setq window (display-buffer buffer)))
          (set-buffer buffer)
          (if (> line-number 0)
              (progn
                (setq old-pos (point))

                ;; this is recommended instead of (goto-line line-number)
                (save-restriction
                  (widen)
                  (goto-char (point-min))
                  (forward-line (1- line-number)))

                (setq old-point (point))

                ;; Here I perform a fuzzy search. If the user has edited the
                ;; sources after building the cscope database, cscope may have
                ;; the wrong line numbers. Here I try to correct for this by
                ;; finding the cscope results in the text around where cscope
                ;; said they should appear. There is a choice here: I could look
                ;; for the original string the user searched for, or I can look
                ;; for the longer string that cscope has found. I do the latter
                (if (and fuzzy-search-text-regexp cscope-fuzzy-search-range)
                    (progn
                      ;; Calculate the length of the line specified by cscope.
                      (end-of-line)
                      (setq line-end (point))
                      (goto-char old-point)
                      (setq line-length (- line-end old-point))

                      ;; Search forward and backward for the pattern.
                      (setq forward-point (re-search-forward
                                           fuzzy-search-text-regexp
                                           (+ old-point
                                              cscope-fuzzy-search-range) t))
                      (goto-char old-point)
                      (setq backward-point (re-search-backward
                                            fuzzy-search-text-regexp
                                            (- old-point
                                               cscope-fuzzy-search-range) t))
                      (if forward-point
                          (progn
                            (if backward-point
                                (setq new-point
                                      ;; Use whichever of forward-point or
                                      ;; backward-point is closest to old-point.
                                      ;; Give forward-point a line-length advantage
                                      ;; so that if the symbol is on the current
                                      ;; line the current line is chosen.
                                      (if (<= (- (- forward-point line-length)
                                                 old-point)
                                              (- old-point backward-point))
                                          forward-point
                                        backward-point))
                              (setq new-point forward-point)))
                        (if backward-point
                            (setq new-point backward-point)
                          (setq new-point old-point)))
                      (goto-char new-point)
                      (beginning-of-line)
                      (setq new-point (point)))
                  (setq new-point old-point))
                (set-window-point window new-point)

                ;; if we're using an arrow overlay....
                (if (and cscope-allow-arrow-overlays arrow-p)
                    (set-marker

                     ;; ... set the existing marker if there is one, or make a
                     ;; new one ...
                     (or overlay-arrow-position
                         (setq overlay-arrow-position (make-marker)))

                     ;; ... at point
                     (point))

                  ;; if we need to remove a marker, do that if there is one
                  (when overlay-arrow-position
                    (set-marker overlay-arrow-position nil)))

                (or (not save-mark-p)
                    (= old-pos (point))
                    (push-mark old-pos))
                ))

          (if cscope-marker
              (progn ;; The search was successful.  Save the marker so it
                     ;; can be returned to by cscope-pop-mark.
                (ring-insert cscope-marker-ring cscope-marker)
                ;; Unset cscope-marker so that moving between matches does not
                ;; fill cscope-marker-ring.
                (setq cscope-marker nil)))
          (setq cscope-marker-window window)
          )
      (message "No entry found at point."))
    )
  window)

(provide 'init-cscope)
