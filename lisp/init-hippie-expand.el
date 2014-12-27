;; "M-/"自动补全功能
;; (setq hippie-expand-try-functions-list
;;       '(try-expand-dabbrev                 ; 搜索当前 buffer
;;         try-expand-dabbrev-visible         ; 搜索当前可见窗口
;;         try-expand-dabbrev-all-buffers     ; 搜索所有 buffer
;;         try-expand-dabbrev-from-kill       ; 从 kill-ring 中搜索
;;         try-complete-file-name-partially   ; 文件名部分匹配
;;         try-complete-file-name             ; 文件名匹配
;;         try-expand-all-abbrevs             ; 匹配所有缩写词
;;         try-expand-list                    ; 补全一个列表
;;         try-expand-line                    ; 补全当前行
;;         try-complete-lisp-symbol-partially ; 部分补全 elisp symbol
;;         try-complete-lisp-symbol))         ; 补全 lisp symbol

(global-set-key (kbd "M-/") 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

(provide 'init-hippie-expand)
