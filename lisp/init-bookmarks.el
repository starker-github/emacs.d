;; Book mark 1
(global-set-key "\C-c!" 'bookmark-jump-default1)
(defun bookmark-jump-default1 (pos)
  (interactive "d")
  (bookmark-jump "default-bookmark1")
  (bookmark-set "default-bookmark1")
  (message "Jump bookmark1"))

(global-set-key "\C-c1" 'bookmark-set-default1)
(defun bookmark-set-default1 (pos)
  (interactive "d")
  (bookmark-set "default-bookmark1")
  (message "Set bookmark1"))

;; Book mark 2
(global-set-key "\C-c@" 'bookmark-jump-default2)
(defun bookmark-jump-default2 (pos)
  (interactive "d")
  (bookmark-jump "default-bookmark2")
  (bookmark-set "default-bookmark2")
  (message "Jump bookmark2"))

(global-set-key "\C-c2" 'bookmark-set-default2)
(defun bookmark-set-default2 (pos)
  (interactive "d")
  (bookmark-set "default-bookmark2")
  (message "Set bookmark2"))

;; Book mark 3
(global-set-key "\C-c#" 'bookmark-jump-default3)
(defun bookmark-jump-default3 (pos)
  (interactive "d")
  (bookmark-jump "default-bookmark3")
  (bookmark-set "default-bookmark3")
  (message "Jump bookmark3"))

(global-set-key "\C-c3" 'bookmark-set-default3)
(defun bookmark-set-default3 (pos)
  (interactive "d")
  (bookmark-set "default-bookmark3")
  (message "Set bookmark3"))

;; Book mark 4
(global-set-key "\C-c$" 'bookmark-jump-default4)
(defun bookmark-jump-default4 (pos)
  (interactive "d")
  (bookmark-jump "default-bookmark4")
  (bookmark-set "default-bookmark4")
  (message "Jump bookmark4"))

(global-set-key "\C-c4" 'bookmark-set-default4)
(defun bookmark-set-default4 (pos)
  (interactive "d")
  (bookmark-set "default-bookmark4")
  (message "Set bookmark4"))

;; Book mark 5
(global-set-key "\C-c%" 'bookmark-jump-default5)
(defun bookmark-jump-default5 (pos)
  (interactive "d")
  (bookmark-jump "default-bookmark5")
  (bookmark-set "default-bookmark5")
  (message "Jump bookmark5"))

(global-set-key "\C-c5" 'bookmark-set-default5)
(defun bookmark-set-default5 (pos)
  (interactive "d")
  (bookmark-set "default-bookmark5")
  (message "Set bookmark5"))

(global-set-key "\C-c)" 'bookmark-jump)
(global-set-key "\C-c0" 'bookmark-set)
(global-set-key "\C-c8" 'bookmark-bmenu-list)
(global-set-key "\C-c9" 'bookmark-delete)

(provide 'init-bookmarks)
