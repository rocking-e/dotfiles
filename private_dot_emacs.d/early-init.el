(menu-bar-mode 1)
(scroll-bar-mode 1)
(tool-bar-mode 1)

;;; Set frame size and position
(add-to-list 'default-frame-alist '(left . 90))
(add-to-list 'default-frame-alist '(top . 40))
;;;(add-hook 'emacs-startup-hook
;;;          (lambda ()
;;;            (let ((frame-width (frame-pixel-width))
;;;                  (screen-width (display-pixel-width)))
;;;              (set-frame-position (selected-frame) (- screen-width frame-width) 30))))
