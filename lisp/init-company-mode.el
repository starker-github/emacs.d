(require-package 'company)
;; (require-package 'company-c-headers)

;; 显示数字，并能通过数字选择
(setq company-show-numbers t)
(defun ora-company-number ()
  "Forward to `company-complete-number'.

Unless the number is potentially part of the candidate.
In that case, insert the number."
  (interactive)
  (let* ((k (this-command-keys))
         (re (concat "^" company-prefix k)))
    (if (cl-find-if (lambda (s) (string-match re s))
                    company-candidates)
        (self-insert-command 1)
      (company-complete-number (string-to-number k)))))
(with-eval-after-load 'company
  (let ((map company-active-map))
    (mapc
     (lambda (x)
       (define-key map (format "%d" x) 'ora-company-number))
     (number-sequence 0 9))
    (define-key map " " (lambda ()
                          (interactive)
                          (company-abort)
                          (self-insert-command 1)))
    (define-key map (kbd "<return>") nil)))

;; c headers
;; (require 'company-c-headers)
;; (add-to-list 'company-c-headers-path-system "/mnt/tao/Utils/compiler/mips-gcc520-glibc222/mips-linux-gnu/include/c++/5.2.0/")
;; (add-to-list 'company-c-headers-path-system "/mnt/tao/Utils/compiler/mips-gcc520-glibc222/mips-linux-gnu/libc/usr/include")
;; (add-to-list 'company-c-headers-path-system "/mnt/tao/Documents/A_AIP/codes/webrtc/JzAsp")

;; (add-hook 'c++-mode-hook
;;           (lambda () (setq flycheck-clang-include-path
;;                            (list "/mnt/tao/Documents/A_AIP/codes/webrtc/JzAsp"))))

;; yasnippet
(require 'init-yasnippet)

;; fci-mode
(defvar-local company-fci-mode-on-p nil)

(defun company-turn-off-fci (&rest ignore)
  (when (boundp 'fci-mode)
    (setq company-fci-mode-on-p fci-mode)
    (when fci-mode (fci-mode -1))))

(defun company-maybe-turn-on-fci (&rest ignore)
  (when company-fci-mode-on-p (fci-mode 1)))

(add-hook 'company-completion-started-hook 'company-turn-off-fci)
(add-hook 'company-completion-finished-hook 'company-maybe-turn-on-fci)
(add-hook 'company-completion-cancelled-hook 'company-maybe-turn-on-fci)

;; forend emacs2.6
; (require-package 'company-childframe)

;; math
(require-package 'company-math)

;; quickhelp
(require-package 'company-quickhelp)
(company-quickhelp-mode)

;; color
(setq company-idle-delay 10)
(setq company-tooltip-idle-delay .1)
(setq company-echo-delay 0)
(require 'color)
(custom-set-faces
 '(company-scrollbar-bg ((t (:background "darkgray" :foreground "black"))))
 '(company-scrollbar-fg ((t (:background "gray35"))))
 '(company-preview ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold)) (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:inherit company-tooltip-selection)))))

;; ctags
;(setq-default tags-table-list (list "/mnt/tao/Documents/A_AIP/codes/webrtc/JzAsp/"))
(setq-default tags-table-list nil)

;; irony
(require-package 'irony)
(require-package 'irony-eldoc)
(require-package 'company-irony)
(require-package 'company-irony-c-headers)

(require 'irony)
(require 'irony-cdb)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(add-hook 'irony-mode-hook #'irony-eldoc)

(setq irony-additional-clang-options '("-I/mnt/tao/Documents/A_AIP/codes/webrtc/JzAsp"))

;; dabbrev
(setq company-dabbrev-downcase nil)
(setq company-dabbrev-ignore-case nil)

;; backends
(with-eval-after-load 'company
  (add-hook 'c-mode-common-hook (lambda ()
                                  (set (make-local-variable 'company-backends)
                                       '(company-files
                                         (company-dabbrev company-yasnippet company-irony-c-headers company-irony company-keywords))))))

;                                        (company-yasnippet company-irony-c-headers company-irony company-keywords company-dabbrev-code)
;                                         (company-c-headers company-yasnippet company-gtags company-etags company-keywords company-dabbrev-code company-clang)


(setq tab-always-indent 'complete)
(global-set-key (kbd "<tab>") 'company-complete-common)
(global-set-key (kbd "C-i") 'indent-for-tab-command)
(add-hook 'after-init-hook 'global-company-mode)

(provide 'init-company-mode)
