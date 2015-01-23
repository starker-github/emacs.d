(defun get-ip-address (&optional dev)
  "get the IP-address for device DEV (default: eth0)"
  (let ((dev (if dev dev "eth0")))
    (format-network-address (car (network-interface-info dev)) t)))
;(setq local-ip (get-ip-address))

(if (not (boundp 'server-base))
    (setq server-base "/ssh:tao@192.168.1.24:.emacs.d/"))

(defun cp_elpa (name dst)
  (let (dir)
    (setq dir (concat "/home/" name "/.emacs.d/elpa"))
    (and (file-directory-p dir)
         (message (concat "cp -a " dir " " dst))
         (shell-command (concat "cp -a " dir " " dst))))
  )

(setq local-directory "~/.emacs_tao/")
;(shell-command (concat "mkdir -m=666 " local-directory))
(setq user-emacs-directory local-directory)
(cp_elpa "tjiang" local-directory)
(cp_elpa "tao" local-directory)

(add-to-list 'load-path server-base)
(require 'init)

(provide 'init-server)
