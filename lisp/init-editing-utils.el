(require 'json-mode)
(require 'json-reformat)
(require-package 'unfill)

(global-unset-key (kbd "C-SPC"))

;; 括号自动补全
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))
(when (eval-when-compile (version< "24.4" emacs-version))
  (electric-indent-mode 1))

;;----------------------------------------------------------------------------
;; Some basic preferences
;;----------------------------------------------------------------------------
(setq-default
 blink-cursor-interval 0.4
 bookmark-default-file (expand-file-name ".bookmarks.el" user-emacs-directory)
 buffers-menu-max-size 30
 case-fold-search t
 column-number-mode t                   ;在modeline显示行号
 delete-selection-mode t
 ediff-split-window-function 'split-window-horizontally ; ediff默认水平分隔
 ediff-window-setup-function 'ediff-setup-windows-plain
 indent-tabs-mode nil                   ;不能输入tab
 make-backup-files nil                  ;关闭自动备份
 mouse-yank-at-point t                  ;粘贴于光标处
 save-interprogram-paste-before-kill t
 scroll-preserve-screen-position 'always ;翻页时不改变屏幕的位置
 set-mark-command-repeat-pop t           ;C-u C-@后,使用C-@在标记环间跳跃
 show-trailing-whitespace t              ;显示行尾空格
 tooltip-delay 1.5
 truncate-lines nil                      ;关闭拆行功能
 truncate-partial-width-windows nil
 visible-bell t)                         ;关闭响铃

;; modeline显示函数名
(which-function-mode)

;;页面平滑滚动， scroll-margin 3 靠近屏幕边沿3行时开始滚动，可以很好的看到上下文。
(setq scroll-margin 5
  scroll-conservatively 10000)
;;允许emacs和外部其他程序的粘贴
(setq x-select-enable-clipboard t)
;; 当光标在行尾上下移动的时候，始终保持在行尾。
(setq track-eol t)

(global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t
  auto-revert-verbose nil)

(setq kill-ring-max 100)                ;设置删除记录
(transient-mark-mode t)                 ;高亮选中的文本
(setq backup-directory-alist (quote (("." . "~/.emacs.d/.backups"))))

;;设置 sentence-end 可以识别中文标点。不用在 fill 时在句号后插入两个空格。
(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)


;;; Whitespace

(defun sanityinc/no-trailing-whitespace ()
  "Turn off display of trailing whitespace in this buffer."
  (setq show-trailing-whitespace nil))

;; But don't show trailing whitespace in SQLi, inf-ruby etc.
(dolist (hook '(special-mode-hook
                eww-mode-hook
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook
                twittering-mode-hook
                minibuffer-setup-hook))
  (add-hook hook #'sanityinc/no-trailing-whitespace))


(require-package 'whitespace-cleanup-mode)
(global-whitespace-cleanup-mode t)

(global-set-key [remap just-one-space] 'cycle-spacing)
(global-set-key (kbd "C-`") 'whitespace-cleanup)

;(require-package 'clean-aindent-mode)
(require 'clean-aindent-mode)
(clean-aindent-mode)

(defun pre-auto-indent()
  (if (not (listp this-command))
      (if (string= "newline-and-indent" this-command)
       (c-indent-line-or-region))))

(add-hook 'pre-command-hook 'pre-auto-indent)


;;; Newline behaviour

(global-set-key (kbd "RET") 'newline-and-indent)
(defun sanityinc/newline-at-end-of-line ()
  "Move to end of line, enter a newline, and reindent."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

;; S-<return> 在行尾打开一个新行
(global-set-key (kbd "S-<return>") 'sanityinc/newline-at-end-of-line)



;; subword: 改变关于word命令的行为
(when (eval-when-compile (string< "24.3.1" emacs-version))
  ;; https://github.com/purcell/emacs.d/issues/138
  (after-load 'subword
    (diminish 'subword-mode)))



;; 将各种标识/符号的文本展示用更美观的字符代替
;; (when (fboundp 'global-prettify-symbols-mode)
;;   (global-prettify-symbols-mode))


(require-package 'undo-tree)
(global-undo-tree-mode)
(diminish 'undo-tree-mode)


;; 高亮当前光标所在的符号
(require-package 'highlight-symbol)
;; (dolist (hook '(prog-mode-hook html-mode-hook css-mode-hook))
;;   (add-hook hook 'highlight-symbol-mode)
;;   (add-hook hook 'highlight-symbol-nav-mode))
;; (eval-after-load 'highlight-symbol
;;   '(diminish 'highlight-symbol-mode))

;; [BUG] 第一次highlight-symbol-at-point的单词,即使取消了高亮,颜色仍然不变.
;; [原因] hi-lock.el中定义了(defalias 'highlight-symbol-at-point 'hi-lock-face-symbol-at-point)
;;        导致其实调用的是hi-lock-face-symbol-at-point,所以需要require highlight-symbol重新定义
;;        highlight-symbol-at-point
(require 'highlight-symbol)

(defun highlight-symbol ()
  "Toggle highlighting of the symbol at point.
This highlights or unhighlights the symbol at point using the first
element in of `highlight-symbol-faces'."
  (interactive)
  (let ((symbol (highlight-symbol-get-symbol)))
    (unless symbol (error "No symbol at point"))
    (if (highlight-symbol-symbol-highlighted-p symbol)
        (highlight-symbol-remove-symbol symbol)
      (highlight-symbol-add-symbol symbol))))

;(global-set-key (kbd"C-; C-;") 'highlight-symbol-at-point)
(global-set-key (kbd"C-; C-;") 'highlight-symbol)
(global-set-key (kbd"C-; C-n") 'highlight-symbol-next)
(global-set-key (kbd"C-; C-p") 'highlight-symbol-prev)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key (kbd"C-; C-a") 'highlight-symbol-replace)
(global-set-key (kbd"C-; C-r") 'highlight-symbol-query-replace)
(global-set-key (kbd"C-; C-g") 'highlight-symbol-remove-all)
;(global-set-key (kbd"C-; C-s") 'highlight-regexp)
(global-set-key (kbd"C-; C-s") 'hi-lock-face-buffer)
(global-set-key (kbd"C-; C-l") 'hi-lock-line-face-buffer)
(global-set-key (kbd"C-; C-m") 'hi-lock-unface-buffer)

;;----------------------------------------------------------------------------
;; Zap *up* to char is a handy pair for zap-to-char
;;----------------------------------------------------------------------------
;; 不kill参数
(autoload 'zap-up-to-char "misc" "Kill up to, but not including ARGth occurrence of CHAR.")
(global-set-key (kbd "M-Z") 'zap-up-to-char)



(require-package 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; copy region or whole line
(global-set-key "\C-w"
                (lambda ()
                  (interactive)
                  (if mark-active
                      (kill-ring-save (region-beginning)
                                      (region-end))
                    (progn
                     (kill-ring-save (line-beginning-position)
                                     (line-end-position))
                     (message "copied line")))))

;; kill region or whole line
(global-set-key "\M-w"
                (lambda ()
                  (interactive)
                  (if mark-active
                      (kill-region (region-beginning)
                                   (region-end))
                    (progn
                     (kill-region (line-beginning-position)
                                  (line-end-position))
                     (delete-char 1)
                     (message "killed line")))))

;; paste at next line
(defun paste-at-next ()
  "paste next line"
  (interactive)
  (end-of-line nil)
  (newline nil)
  (cua-paste nil))
(global-set-key "\C-y" 'paste-at-next)

;;----------------------------------------------------------------------------
;; Don't disable narrowing commands
;;----------------------------------------------------------------------------
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;;----------------------------------------------------------------------------
;; Show matching parens
;; 显示匹配的括号
;;----------------------------------------------------------------------------
(show-paren-mode 1)
(setq show-paren-style 'parentheses)

;;----------------------------------------------------------------------------
;; Expand region
;; 增量选择区域
;;----------------------------------------------------------------------------
(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)


;;----------------------------------------------------------------------------
;; Don't disable case-change functions
;;----------------------------------------------------------------------------
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;;----------------------------------------------------------------------------
;; Rectangle selections, and overwrite text when the selection is active
;;----------------------------------------------------------------------------
(cua-mode t)
;;(cua-selection-mode t)                  ; for rectangles, CUA is nice

;;----------------------------------------------------------------------------
;; Handy key bindings
;;----------------------------------------------------------------------------
;; To be able to M-x without meta, 等同与M-x
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

;; Vimmy alternatives to M-^ and C-u M-^
(global-set-key (kbd "C-c j") 'join-line)
(global-set-key (kbd "C-c J") (lambda () (interactive) (join-line 1)))

;; 设置mark
(global-set-key (kbd "C-.") 'set-mark-command)
(global-set-key (kbd "C-x C-.") 'pop-global-mark)
(global-set-key (kbd "M-[") 'beginning-of-buffer)
(global-set-key (kbd "M-]") 'end-of-buffer)

;; goto char
(require-package 'ace-jump-mode)
(global-set-key (kbd "C-'") 'ace-jump-char-mode)
(global-set-key (kbd "C-\"") 'ace-jump-word-mode)
;(global-set-key (kbd "C-:") 'ace-jump-word-mode)


(require-package 'multiple-cursors)
;; multiple-cursors
;; 多行编辑: 先选定一个区域,然后调用mark-previous/next-like-this方法,
;; 就会找到相似的位置,可以同时进行编辑
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-+") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;; From active region to multiple cursors:
(global-set-key (kbd "C-c c r") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-c c c") 'mc/edit-lines)
(global-set-key (kbd "C-c c e") 'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c c a") 'mc/edit-beginnings-of-lines)


;; Train myself to use M-f and M-b instead
(global-unset-key [M-left])
(global-unset-key [M-right])


;; "C-M-<backspace"删除到第一不为空的单词
(defun kill-back-to-indentation ()
  "Kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    (back-to-indentation)
    (kill-region (point) prev-pos)))

(global-set-key (kbd "C-M-<backspace>") 'kill-back-to-indentation)


;;----------------------------------------------------------------------------
;; Page break lines
;; 显示分页符
;;----------------------------------------------------------------------------
(require-package 'page-break-lines)
(global-page-break-lines-mode)
(diminish 'page-break-lines-mode)

;;----------------------------------------------------------------------------
;; Fill column indicator
;; 限制一行的最长位置
;;----------------------------------------------------------------------------
(when (eval-when-compile (> emacs-major-version 23))
  (require-package 'fill-column-indicator)
  (defun sanityinc/prog-mode-fci-settings ()
    (turn-on-fci-mode)
    (when show-trailing-whitespace
      (set (make-local-variable 'whitespace-style) '(face trailing))
      (whitespace-mode 1)))

  ;;(add-hook 'prog-mode-hook 'sanityinc/prog-mode-fci-settings)

  (defun sanityinc/fci-enabled-p ()
    (and (boundp 'fci-mode) fci-mode))

  (defvar sanityinc/fci-mode-suppressed nil)
  (defadvice popup-create (before suppress-fci-mode activate)
    "Suspend fci-mode while popups are visible"
    (let ((fci-enabled (sanityinc/fci-enabled-p)))
      (when fci-enabled
        (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-enabled)
        (turn-off-fci-mode))))
  (defadvice popup-delete (after restore-fci-mode activate)
    "Restore fci-mode when all popups have closed"
    (when (and sanityinc/fci-mode-suppressed
               (null popup-instances))
      (setq sanityinc/fci-mode-suppressed nil)
      (turn-on-fci-mode)))

  ;; Regenerate fci-mode line images after switching themes
  (defadvice enable-theme (after recompute-fci-face activate)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (sanityinc/fci-enabled-p)
          (turn-on-fci-mode))))))

(setq-default fill-column 100)
(require 'fill-column-indicator)

;;----------------------------------------------------------------------------
;; Shift lines up and down with M-up and M-down. When paredit is enabled,
;; it will use those keybindings. For this reason, you might prefer to
;; use M-S-up and M-S-down, which will work even in lisp modes.
;; 移动行: "M-up"上移,"M-down"下移动
;;----------------------------------------------------------------------------
(require-package 'move-dup)
(global-set-key [M-up] 'md/move-lines-up)
(global-set-key [M-down] 'md/move-lines-down)
(global-set-key [M-S-up] 'md/move-lines-up)
(global-set-key [M-S-down] 'md/move-lines-down)

;; C-c p向下复制一行
;; C-c P向上复制一行
(global-set-key (kbd "C-c p") 'md/duplicate-down)
(global-set-key (kbd "C-c P") 'md/duplicate-up)

;;----------------------------------------------------------------------------
;; Fix backward-up-list to understand quotes, see http://bit.ly/h7mdIL
;; 跳转到本级括号或者上一级括号
;;----------------------------------------------------------------------------
(defun backward-up-sexp (arg)
  "Jump up to the start of the ARG'th enclosing sexp."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

(global-set-key [remap backward-up-list] 'backward-up-sexp) ; C-M-u, C-M-up


;;----------------------------------------------------------------------------
;; Cut/copy the current line if no region is active
;;----------------------------------------------------------------------------
(require-package 'whole-line-or-region)
(whole-line-or-region-mode t)
(diminish 'whole-line-or-region-mode)
(make-variable-buffer-local 'whole-line-or-region-mode)

(defun suspend-mode-during-cua-rect-selection (mode-name)
  "Add an advice to suspend `MODE-NAME' while selecting a CUA rectangle."
  (let ((flagvar (intern (format "%s-was-active-before-cua-rectangle" mode-name)))
        (advice-name (intern (format "suspend-%s" mode-name))))
    (eval-after-load 'cua-rect
      `(progn
         (defvar ,flagvar nil)
         (make-variable-buffer-local ',flagvar)
         (defadvice cua--activate-rectangle (after ,advice-name activate)
           (setq ,flagvar (and (boundp ',mode-name) ,mode-name))
           (when ,flagvar
             (,mode-name 0)))
         (defadvice cua--deactivate-rectangle (after ,advice-name activate)
           (when ,flagvar
             (,mode-name 1)))))))

(suspend-mode-during-cua-rect-selection 'whole-line-or-region-mode)




(defun sanityinc/open-line-with-reindent (n)
  "A version of `open-line' which reindents the start and end positions.
If there is a fill prefix and/or a `left-margin', insert them
on the new line if the line would have been blank.
With arg N, insert N newlines."
  (interactive "*p")
  (let* ((do-fill-prefix (and fill-prefix (bolp)))
         (do-left-margin (and (bolp) (> (current-left-margin) 0)))
         (loc (point-marker))
         ;; Don't expand an abbrev before point.
         (abbrev-mode nil))
    (delete-horizontal-space t)
    (newline n)
    (indent-according-to-mode)
    (when (eolp)
      (delete-horizontal-space t))
    (goto-char loc)
    (while (> n 0)
      (cond ((bolp)
             (if do-left-margin (indent-to (current-left-margin)))
             (if do-fill-prefix (insert-and-inherit fill-prefix))))
      (forward-line 1)
      (setq n (1- n)))
    (goto-char loc)
    (end-of-line)
    (indent-according-to-mode)))

(global-set-key (kbd "C-o") 'sanityinc/open-line-with-reindent)


;;----------------------------------------------------------------------------
;; Random line sorting
;; 随机排列
;;----------------------------------------------------------------------------
(defun sort-lines-random (beg end)
  "Sort lines in region randomly."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let ;; To make `end-of-line' and etc. to ignore fields.
          ((inhibit-field-text-motion t))
        (sort-subr nil 'forward-line 'end-of-line nil nil
                   (lambda (s1 s2) (eq (random 2) 0)))))))




(require-package 'highlight-escape-sequences)
(hes-mode)


;; 按键导航, 按键后自动弹出提示
(require-package 'guide-key)
(setq guide-key/guide-key-sequence '("C-x" "C-c" "C-x 4" "C-x 5" "C-c ;" "C-c ; f" "C-c ' f" "C-x n"))
(guide-key-mode 1)
(diminish 'guide-key-mode)


;;------------------------- 括号匹配 -------------------------------------------
; 这是一个很小的函数。你是不是觉得Emacs在匹配的括号之间来回跳转的时候按C-M-f
; 和C-M-b太麻烦了?vi的%就很方便,我们可以把%设置为匹配括号。可是你想输入%怎么办?
; 一个很巧妙的解决方案就是.当%在括号上按下时.那么匹配括号.否则输入一个%.
; 你只需要在 .emacs文件里加入这些东西就可以达到目的
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
 "Go to the matching paren if on a paren; otherwise insert %."
 (interactive "p")
 (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
  ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
  (t (self-insert-command (or arg 1)))))

;;; **************************************************************************
;;; ******* remove M^
;;; **************************************************************************
(defun dos-unix () (interactive)
   (goto-char (point-min))
   (while (search-forward "\r" nil t) (replace-match "")))
(defun unix-dos () (interactive)
   (goto-char (point-min))
   (while (search-forward "\n" nil t) (replace-match "\r\n")))

;;------------------------- insert debuig text -------------------------------------------
(defun insert-deb-texta()
  (interactive)
  (end-of-line nil)
  (indent-new-comment-line)
  (insert "printf(\"#### {%s, %s, %d} ####\\n\", __FILE__, __func__, __LINE__);"))
;;  (indent-region (line-beginning-position)
;;                 (line-end-position)))
(global-set-key (kbd"C-M-; a") 'insert-deb-texta)

(defun insert-deb-texts()
  (interactive)
  (end-of-line nil)
  (indent-new-comment-line)
  (insert "printf(\"====> {%s, %s, %d} <====\\n\", __FILE__, __func__, __LINE__);"))
;;  (indent-region (line-beginning-position)
;;                 (line-end-position)))
(global-set-key (kbd"C-M-; s") 'insert-deb-texts)

(defun insert-deb-textd()
  (interactive)
  (end-of-line nil)
  (indent-new-comment-line)
  (insert "printf(\"**** {%s, %s, %d} ****\\n\", __FILE__, __func__, __LINE__);"))
;;  (indent-region (line-beginning-position)
;;                 (line-end-position)))
(global-set-key (kbd"C-M-; d") 'insert-deb-textd)

(defun insert-deb-textq()
  (interactive)
  (end-of-line nil)
  (indent-new-comment-line)
  (insert "/* TODO-tjiang:  */")
  (left-char)
  (left-char)
  (left-char))
(global-set-key (kbd"C-M-; q") 'insert-deb-textq)

(defun insert-deb-textw()
  (interactive)
  (end-of-line nil)
  (indent-new-comment-line)
  (insert "/* FIXME-tjiang:  */")
  (left-char)
  (left-char)
  (left-char))
(global-set-key (kbd"C-M-; w") 'insert-deb-textw)

(require'linum)
;(global-linum-mode t)
(global-set-key "\M-n" 'linum-mode)

(require-package 'cmake-mode)
(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
        ("\\.cmake\\'" . cmake-mode))
          auto-mode-alist))

(provide 'init-editing-utils)
