(defvar jl-insert-marker-funcs
  '("isearch-repeat-forward"
    "isearch-repeat-backward"
    "isearch-forward"
    "evil-search-forward"
    "evil-search-backward"
    "evil-search-backward"
    "evil-search-next"
    "evil-search-previous"
    "evil-search-symbol-forward"
    "evil-search-symbol-backward"

    "beginning-of-buffer"
    "end-of-buffer"
    "next-buffer"
    "previous-buffer"

    "mouse-drag-region"
    "jl-jump-backward"

    "cscope-find-global-definition"
    "cscope-select-entry-other-window"
    "cscope-find-functions-calling-this-function"
    "cscope-find-this-symbol"
    "dired-advertised-find-file"
    "find-file-at-point"

    "highlight-symbol-next"
    "highlight-symbol-prev"

    "beginning-of-buffer"
    "end-of-buffer"
    "pygmalion-command"

    "mouse-drag-region"
    ;;    "eval-last-sexp"
    )
  "A list of fuctions. When anyone in it is executed, a marker is set.")

(defvar jl-move-marker-funcs
  '("cua-scroll-down"
   "cua-scroll-up"
   "next-line"
   "previous-line"
   "forward-char"
   "backward-char"
   "forward-word"
   "backward-word"
   "left-char"
   "right-char"
   "move-beginning-of-line"
   "move-end-of-line"
   )
  "A list of fuctions. When anyone in it is executed, a marker is set.")

(defvar jl-skip-funcs
  '("self-insert-command"
    )
  "To improve the performance, this list will be scanned first.
   If the command excecuted is in this list, no mark will be set.")

(defvar jl-skip-buffer
  '("*cscope*"
    "*scratch*"
    "*Messages*"
    "*compilation*"
    "*Help*"
    "*Ibuffer*"
    "*Minibuf-1*"
    "work-shell"
    "tmp-shell"
    "aaaa-shell"
    "bbbb-shell"
    "cccc-shell"
    "dddd-shell"
    )
  "Marker won't be set in these buffers.")

(defvar jl-max-marker-nr 20) ;; max number of markers
;(defvar jl-marker-nr 0)      ;; nunber of existing markers
(defvar jl-cur-marker-pos -1) ;; current marker position
;;(defvar jl-marker-list (list (point-marker)))
(defvar jl-marker-list nil)
(defvar jl-last-command nil)

;; To check wheter the string str is in list list
(defun jl-is-in-list(list str)
  (catch 'match
    (while (car list)
      (progn (if (string= (car list) str)
                 (throw 'match 1))
             (setq list (cdr list))))
    nil))

;; To check whether a marker is in marker list
(defun jl-marker-is-in-list(marker)
  (let ((list jl-marker-list))
    (catch 'match
      (while (car list)
        (progn (if (equal (car list) marker)
                   (throw 'match 1))
               (setq list (cdr list))))
      nil)))

(defun jl-insert-marker()
  (let ((marker (point-marker)))
    (or (equal marker (car (nthcdr jl-cur-marker-pos jl-marker-list))) ;marker diff from cur-pos
        (progn (if (> (1+ jl-cur-marker-pos) jl-max-marker-nr) ;full: pop the first.
                   (progn
                     (pop jl-marker-list)
                     (setq jl-cur-marker-pos (1- jl-cur-marker-pos))))
               (if (and (string= this-command "jl-jump-backward") ;jl-jump-backward
                        (not (= jl-cur-marker-pos -1))            ;list isn't empty
                        (equal (cdr (nthcdr jl-cur-marker-pos jl-marker-list)) 'nil)) ;pos is the last one.
                   (setcdr (nthcdr jl-cur-marker-pos jl-marker-list) (list marker))
                 (if (= jl-cur-marker-pos -1)
                     (setq jl-marker-list (list marker)) ;empty
                   (setcdr (nthcdr jl-cur-marker-pos jl-marker-list) (list marker))) ;insert: setcdr
                 (setq jl-cur-marker-pos (1+ jl-cur-marker-pos))))
        )))

(defun jl-jump-to-marker(marker)
  ;; (message "*** jump marker: %s" marker)
  ;; (message "*** jump jl-cur-marker-pos: %s" jl-cur-marker-pos)
  (if (not (eq (current-buffer) (marker-buffer marker)))
      (switch-to-buffer (marker-buffer marker)))
  (goto-char (marker-position marker)))

(defun jl-jump-clear()
  (interactive)
  (setq jl-cur-marker-pos -1)
  (while (> (safe-length jl-marker-list) 0)
    (progn
      ;; (message "length = %d" (safe-length jl-marker-list))
      (pop jl-marker-list))))

(defun jl-jump-dump()
  (interactive)
  (message "===================================================================")
  (message "  cur-pos: %d" jl-cur-marker-pos)
  (message "  list-len: %d" (safe-length jl-marker-list))
  (message "  list: %s" jl-marker-list)
  (message "===================================================================")
  )

(defun jl-jump-backward()
  (interactive)

  (if (< jl-cur-marker-pos 0)
      (progn
        (setq jl-cur-marker-pos 0)
        (return-from jl-jump-backward)))

  ;; FIXME: 这里取jl-marker-pos而不是jl-marker-pos-1的原因是:
  ;;        在jl-jump-backward的pre-command中,程序会添加当前位置,但不会移动
  ;;        jl-cur-marker-pos,所以jl-cur-marker-pos正好指向待跳转的位置.
  (let ((marker (nth jl-cur-marker-pos jl-marker-list)))

    ;; We must handle the condition where buffer containing the marker is deleted,
    (while (and (or (not (markerp marker))
                    (equal nil (marker-buffer marker)))
                (> jl-cur-marker-pos -1))
      (progn (pop (nthcdr jl-cur-marker-pos jl-marker-list)) ;pop nil marker
             (setq jl-cur-marker-pos (1- jl-cur-marker-pos)) ;point to the pre one.
             (setq marker (nth jl-cur-marker-pos jl-marker-list))))

    (if (> jl-cur-marker-pos -1)
        (progn
          (if (or (not (equal (point) (marker-position marker)))
                  (not (equal (current-buffer) (marker-buffer marker))))
              (jl-jump-to-marker marker) ;; jump to the nearest place first

            (progn
              (setq jl-cur-marker-pos
                    (1- jl-cur-marker-pos))
              (jl-jump-backward)))))
    ))

(defun jl-jump-forward()
  (interactive)

  (if (> jl-cur-marker-pos (- (safe-length jl-marker-list) 1))
      (progn
        (setq jl-cur-marker-pos (1- (safe-length jl-marker-list)))
        (return-from jl-jump-forward)))

  (let ((marker (nth jl-cur-marker-pos jl-marker-list)))

    ;; We must handle the condition where buffer containing the marker is deleted,
    (while (and (or (not (markerp marker))
                    (equal nil (marker-buffer marker)))
                (< jl-cur-marker-pos (safe-length jl-marker-list)))
      (progn (pop (nthcdr jl-cur-marker-pos jl-marker-list))
             (setq marker (nth jl-cur-marker-pos jl-marker-list))))

    (if (< jl-cur-marker-pos (safe-length jl-marker-list))
        (progn
          (if (or (not (equal (point) (marker-position marker)))
                  (not (equal (current-buffer) (marker-buffer marker))))
              (jl-jump-to-marker marker) ;; jump to the nearest place first

            (progn
              (setq jl-cur-marker-pos
                    (1+ jl-cur-marker-pos))
              (jl-jump-forward))))
      (setq jl-cur-marker-pos (1- (safe-length jl-marker-list))))
    ))

(defun jl-pre-command-check()
  (if (not (listp this-command))
      (progn
        (if (and (not (jl-is-in-list jl-skip-funcs this-command))
                 (not (jl-is-in-list jl-skip-buffer (buffer-name))))
            (if (or (jl-is-in-list jl-insert-marker-funcs this-command)
                    (and (jl-is-in-list jl-move-marker-funcs this-command)
                         (not (jl-is-in-list jl-move-marker-funcs jl-last-command))))
                    (progn ;(message "===> l in list: %s" this-command)
                           (jl-insert-marker))))
        ;; (message "last-command: %s" jl-last-command)
        ;; (message "buffer-name: %s" (buffer-name))
        ;; (message "<=== func: %s" this-command)
        (setq jl-last-command this-command))))

(add-hook 'pre-command-hook 'jl-pre-command-check)

(global-set-key (kbd "C-o") 'jl-jump-backward)
(global-set-key (kbd "C-S-o") 'jl-jump-forward)

(provide 'jumplist)
