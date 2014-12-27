;;----------------------------------------------------------------------------
;; Navigate window layouts with "C-c <left>" and "C-c <right>"
;;----------------------------------------------------------------------------
;; winner mode: undo/redo windows
(when (fboundp 'winner-mode)
 (setq winner-dont-bind-my-keys t)
 (global-set-key "\C-cz" 'winner-undo)
 (global-set-key "\C-cZ" 'winner-redo)
 (winner-mode 1))

;; Make "C-x o" prompt for a target window when there are more than 2
;; "C-x o"可以选择windows, 没有window-numbering好用
(require-package 'switch-window)
(require 'switch-window)
;(setq switch-window-shortcut-style 'alphabet)
;(global-set-key (kbd "C-x o") 'switch-window)
;; window自动编号，使用M-0...9跳转
(require-package 'window-numbering)
(require 'window-numbering)
(window-numbering-mode 1)

;;----------------------------------------------------------------------------
;; When splitting window, show (other-buffer) in the new window
;;----------------------------------------------------------------------------
(defun split-window-func-with-other-buffer (split-function)
  (lexical-let ((s-f split-function))
    (lambda ()
      (interactive)
      (funcall s-f)
      (set-window-buffer (next-window) (other-buffer)))))

(global-set-key "\C-x2" (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key "\C-x3" (split-window-func-with-other-buffer 'split-window-horizontally))

;; "C-x1"在一个windows时执行的是(winner-undo)
(defun sanityinc/toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

(global-set-key "\C-x1" 'sanityinc/toggle-delete-other-windows)

;;----------------------------------------------------------------------------
;; Rearrange split windows
;;----------------------------------------------------------------------------
(defun split-window-horizontally-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-horizontally))))

(defun split-window-vertically-instead ()
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (split-window-func-with-other-buffer 'split-window-vertically))))

;; 水平和垂直重排，没啥用
;; (global-set-key "\C-x|" 'split-window-horizontally-instead)
;; (global-set-key "\C-x_" 'split-window-vertically-instead)

;; Borrowed from http://postmomentum.ch/blog/201304/blog-on-emacs
(defun sanityinc/split-window()
  "Split the window to see the most recent buffer in the other window.
Call a second time to restore the original window configuration."
  (interactive)
  (if (eq last-command 'sanityinc/split-window)
      (progn
        (jump-to-register :sanityinc/split-window)
        (setq this-command 'sanityinc/unsplit-window))
    (window-configuration-to-register :sanityinc/split-window)
    (switch-to-buffer-other-window nil)))

;; "<f7>" 在另一个window中打开最近的buffer，再按一次恢复之前的window
(global-set-key (kbd "<f7>") 'sanityinc/split-window)
;; "<f6>" 就是执行(switch-to-buffer nil)
;; (global-set-key (kbd "<f6>")
;;                 (lambda ()
;;                   (interactive)
;;                   (switch-to-buffer nil)))

;; window移动函数
(windmove-default-keybindings 'super)

(defun windmove-do-swap-window (dir &optional arg window)
	"Move the buffer to the window at direction DIR.
	DIR, nnARG, and WINDOW are handled as by `windmove-other-window-loc'.
	If no window is at direction DIR, an error is signaled."
	(let ((other-window (windmove-find-other-window dir arg window)))
		(cond ((null other-window)
		(error "No window %s from selected window" dir))
		((and (window-minibuffer-p other-window)
			(not (minibuffer-window-active-p other-window)))
				(error "Minibuffer is inactive"))
		        (t
			        (let ( (old-buffer (window-buffer window)) )
				        (set-window-buffer window (window-buffer other-window))
				        (set-window-buffer other-window old-buffer)
				        (select-window other-window))))))

(defun windmove-do-cover-window (dir &optional arg window)
          "Move the buffer to the window at direction DIR.
          DIR, ARG, and WINDOW are handled as by `windmove-other-window-loc'.
          If no window is at direction DIR, an error is signaled."
          (let ((other-window (windmove-find-other-window dir arg window)))
	          (cond ((null other-window)
		  (error "No window %s from selected window" dir))
		  ((and (window-minibuffer-p other-window)
			 (not (minibuffer-window-active-p other-window)))
			         (error "Minibuffer is inactive"))
		         (t
			         (let ( (old-buffer (window-buffer window)) )
                                         (if (string= "*cscope*" (buffer-name window))()
				         (set-window-buffer other-window old-buffer))
				         (set-window-buffer window old-buffer)
				         (select-window other-window))))))

(defun windmove-do-nothing (dir &optional arg window)
          "Move the buffer to the window at direction DIR.
          DIR, ARG, and WINDOW are handled as by `windmove-other-window-loc'.
          If no window is at direction DIR, an error is signaled."
          (let ((other-window (windmove-find-other-window dir arg window)))
	          (cond ((null other-window)
		  (error "No window %s from selected window" dir))
		  ((and (window-minibuffer-p other-window)
			 (not (minibuffer-window-active-p other-window)))
			         (error "Minibuffer is inactive"))
		         (t
			         (let ( (old-buffer (window-buffer window)) )
				         (select-window other-window))))))

(defun window-swap-buffer-up (&optional arg)
	(interactive "P")
        (windmove-do-swap-window'up arg))

(defun window-swap-buffer-down (&optional arg)
	(interactive "P")
        (windmove-do-swap-window'down arg))

(defun window-swap-buffer-left (&optional arg)
	(interactive "P")
        (windmove-do-swap-window'left arg))

(defun window-swap-buffer-right (&optional arg)
	(interactive "P")
        (windmove-do-swap-window'right arg))

(global-set-key [(control c) up] 'window-swap-buffer-up)
(global-set-key [(control c) down] 'window-swap-buffer-down)
(global-set-key [(control c) left] 'window-swap-buffer-left)
(global-set-key [(control c) right] 'window-swap-buffer-right)

(provide 'init-windows)
