;(require-package 'smart-compile)
(require 'smart-compile)

(global-set-key (kbd "<f12>") 'smart-compile)

(require 'smart-compile nil t)
;;   %F  absolute pathname            ( /usr/local/bin/netscape.bin )
;;   %f  file name without directory  ( netscape.bin )
;;   %n  file name without extention  ( netscape )
;;   %e  extention of file name       ( bin )
(setq smart-compile-alist
      '(("\\.c$"          . "mipsel-linux-gcc -o %n -O2 %f")
        ("\\.[Cc]+[Pp]*$" . "mipsel-linux-g++ -o %n -O2 %f")))

(provide 'init-compile)
