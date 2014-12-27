;; isearch-forward-regexp快捷键: ESC C-s

;; Show number of matches while searching
;; 显示当前匹配文本，预览替换效果和总匹配数的插件，使query-replace更加直观
(when (maybe-require-package 'anzu)
  (global-anzu-mode t)
  (diminish 'anzu-mode)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key [remap query-replace] 'anzu-query-replace))

;; Activate occur easily inside isearch
;; 在搜索模式下，按"C-o"在*occur*中显示出搜索结果
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

;; DEL during isearch should edit the search string, not jump back to the previous result
;; 搜索中del按键的处理
(define-key isearch-mode-map [remap isearch-delete-char] 'isearch-del-char)

;; Search back/forth for the symbol at point
;; See http://www.emacswiki.org/emacs/SearchAtPoint
;; 在搜素模式(C-s)下，按"C-M-w"会把当前位置的单词作为搜索单词（只搜索这个单词）
;; 按"C-w"会作为搜索单词（包含的也会搜索）
(defun isearch-yank-symbol ()
  "*Put symbol at current point into search string."
  (interactive)
  (let ((sym (symbol-at-point)))
    (if sym
        (progn
          (setq isearch-regexp t
                isearch-string (concat "\\_<" (regexp-quote (symbol-name sym)) "\\_>")
                isearch-message (mapconcat 'isearch-text-char-description isearch-string "")
                isearch-yank-flag t))
      (ding)))
  (isearch-search-and-update))

(define-key isearch-mode-map "\C-\M-w" 'isearch-yank-symbol)


;; http://www.emacswiki.org/emacs/ZapToISearch
;; kill当前mark位置到最近搜索点的内容
;; zap-to-char: kill当前位置到最近搜索点的内容
(defun zap-to-isearch (rbeg rend)
  "Kill the region between the mark and the closest portion of
the isearch match string. The behaviour is meant to be analogous
to zap-to-char; let's call it zap-to-isearch. The deleted region
does not include the isearch word. This is meant to be bound only
in isearch mode.  The point of this function is that oftentimes
you want to delete some portion of text, one end of which happens
to be an active isearch word. The observation to make is that if
you use isearch a lot to move the cursor around (as you should,
it is much more efficient than using the arrows), it happens a
lot that you could just delete the active region between the mark
and the point, not include the isearch word."
  (interactive "r")
  (when (not mark-active)
    (error "Mark is not active"))
  (let* ((isearch-bounds (list isearch-other-end (point)))
         (ismin (apply 'min isearch-bounds))
         (ismax (apply 'max isearch-bounds))
         )
    (if (< (mark) ismin)
        (kill-region (mark) ismin)
      (if (> (mark) ismax)
          (kill-region ismax (mark))
        (error "Internal error in isearch kill function.")))
    (isearch-exit)
    ))

(define-key isearch-mode-map [(meta z)] 'zap-to-isearch)


;; http://www.emacswiki.org/emacs/ZapToISearch
;; 在搜素模式(C-s)下，按"C enter"进行搜素，定位到搜索字符串的另一端
;; 也就是字符串的开始，并且会推出搜索模式
;; 适合跟着对字符串的操作
(defun isearch-exit-other-end (rbeg rend)
  "Exit isearch, but at the other end of the search string.
This is useful when followed by an immediate kill."
  (interactive "r")
  (isearch-exit)
  (goto-char isearch-other-end))

(define-key isearch-mode-map [(control return)] 'isearch-exit-other-end)


(provide 'init-isearch)
