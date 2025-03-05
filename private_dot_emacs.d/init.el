;; This is an Emacs initialization file.
;; Add Emacs-Lisp code here that should be executed whenever
;; you start Emacs. If errors occur, Emacs will stop
;; evaluating this file and print errors in the *Messags* buffer.
;; Use this file in place of ~/.emacs (which is loaded as well.)

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "davide")

;; In the spirit of sharing, I'm using most of the configuration found in
;; Emacs: a basic and capable configuration
;; https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/
(setq new-init-file (locate-user-emacs-file "new-init.el"))
(load new-init-file :no-error-if-file-is-missing)

;;; Add my elisp directorey
(setq my-elisp-dir (locate-user-emacs-file (concat (getenv "USER") "-lisp")))
(add-to-list #'load-path my-elisp-dir)

(require 'misc-funcs)

(setq 
 require-final-newline t
 dabbrev-case-fold-search nil
 eval-expression-print-length 100
)

;;; Setup hook functions to customize various modes.                                
;;;(add-hook 'term-setup-hook 'term-setup-v21)
(add-hook 'c-mode-hook
          #'(lambda ()
             (setq fill-column 75)
             (turn-on-auto-fill)
             (setq c-comment-continuation-stars nil)
             (set-c-style "bsd")))
(add-hook 'shell-mode-hook
          #'(lambda ()
             (define-key shell-mode-map "\C-c\C-i" 'send-invisible)
             (define-key shell-mode-map "\M-\C-i" 'shell-file-name-completion)
             (setq shell-pushd-regexp "pushd\\|p")))
;;;(add-hook 'perl-mode-hook 'dwe-perl-mode-hook)
;;;(add-hook 'cperl-mode-hook 'dwe-perl-mode-hook)
;;;(defun dwe-perl-mode-hook ()
;;;  (setq fill-column 78)
;;;  (turn-on-auto-fill)
;;;  (setq cperl-indent-level 4)
;;;  (setq cperl-continued-statement-offset 4)
;;;)
;;;(add-hook 'perldb-mode-hook
;;;          #'(lambda ()
;;;             (local-set-key "\C-c\C-i" 'send-invisible)))
(add-hook 'emacs-lisp-mode-hook
          #'(lambda ()
             (turn-on-auto-fill)
             (setq fill-column 78)))

;;;(add-hook 'dired-mode-hook
;;;      #'(lambda ()
;;;         (require 'dired-ns)
;;;         (define-key dired-mode-map "\C-d" 'dired-delete-this-file)
;;;         (define-key dired-mode-map "<" 'dired-edit-superior-directory)
;;;         (define-key dired-mode-map "e" 'dired-find-file-read-only)
;;;         (define-key dired-mode-map "Q" 'dired-quit)
;;;         (define-key dired-mode-map "N" 'AJK::dired-send-to-netscape)
;;;;;       (define-key dired-mode-map "q" 'dired-delete-and-exit)                     
;;;         ))
;;;(add-hook 'lisp-mode-hook #'(lambda () (setq inferior-lisp-prompt "^.*> *$")))
(add-hook 'text-mode-hook
      #'(lambda ()
         (turn-on-auto-fill)
;;;         (turn-on-filladapt-mode)
         (local-set-key "\t" 'indent-according-to-mode)
         (make-local-variable 'indent-line-function)
         (setq indent-line-function 'indent-relative-maybe)))
(defun turn-on-filladapt-mode ()
  "Do nothing"
  nil)

;;; Define a Meta-o map for nifty functions. Meta-o used to be the one meta key 
;;; that did not already have a binding. Normally Meta-o is used by vt100
;;; type keyboards for the keypad keys. 
(defvar esc-o-map ()
  "Keymap used for META-o prefixing")
(if (not esc-o-map)
    (setq esc-o-map (make-sparse-keymap)))
(define-key esc-map   "o"    esc-o-map)
;;;(define-key global-map `[(,osxkeys-command-key control o)] esc-o-map)
(define-key esc-o-map "c"       'center-line)
(define-key esc-o-map "t"       'line-to-top)
(define-key esc-o-map "b"       'line-to-bottom)
(define-key esc-o-map "m"       'manual-entry)
(define-key esc-o-map "w"       'webster)
(define-key esc-o-map "s"       'webster-spell)
(define-key esc-o-map "v"       'view-current-buffer)
(define-key esc-o-map "]"       'interactive-blink-matching-open)
(define-key esc-o-map ";"       'lisp-comment-region)
(define-key esc-o-map " "       'change-tab-width-to-4)
(define-key esc-o-map "i"       'insert-box)
(define-key esc-o-map "\M-o"    'compile-with-same-commands)
(define-key esc-o-map "o"       'compile-with-same-commands)

;;; From: fish@cs.utah.edu (Russ Fish)
;;; Date: 5 Nov 90 19:42:37 GMT
;;; Organization: University of Utah CS Dept
;;;
; Electric help, avoids mucking up the window layout with the *Help* buffer.
;(if (load "ehelp" 'missing-ok)
;  (define-key global-map "\C-h" 'ehelp-command))
(require 'ehelp)
(if (fboundp 'ehelp-command)
    (define-key global-map "\C-h" 'ehelp-command))
(setq electric-help-mode-hook 'my-electric-keys)

; Electric-buffer-list pops up window to select/manipulate buffers.
(global-set-key "\^X\^B" 'electric-buffer-list)         ; ^X-^B.
(setq electric-buffer-menu-mode-hook
      #'(lambda ()
         (local-set-key "e" 'Buffer-menu-execute)
         (my-electric-keys)
         (local-set-key "x" 'Buffer-menu-execute)))

; Make the electric modes more useful by adding searching and copying.
(defun my-electric-keys ()
  "Additional key bindings for electric window modes."
;  (local-set-key "a"   'fast-apropos)
;  (local-set-key "A"   'super-apropos)
  (local-set-key "\^s" 'isearch-forward)
  (local-set-key "\^r" 'isearch-backward)
  (local-set-key "\^f" 'forward-char)
  (local-set-key "\^b" 'backward-char)
  (local-set-key "\^a" 'beginning-of-line)
  (local-set-key "\^e" 'end-of-line)
  (local-set-key "\ef" 'forward-word)
  (local-set-key "\eb" 'backward-word)
  (local-set-key "\^@" 'set-mark-command)
  (local-set-key "\ew" 'copy-region-as-kill))


;; Puppet file handling.
;; From https://github.com/puppetlabs/puppet-syntax-emacs
(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(autoload 'terraform-mode "terraform-mode"
  "Major mode for editing terraform description files" t)
(add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-mode))

(autoload 'powershell-mode "powershell-mode"
  "Major mode for editing powershell scripts" t)
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode))
; Package manager setup (http://www.emacswiki.org/emacs/ELPA)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))

;;;https://github.com/zenspider/enhanced-ruby-mode
;;;(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)
;;;(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
;;;(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
; Make enter key to newline-and-indent
(add-hook 'yaml-mode-hook
	  #'(lambda ()
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;; Dockerfile https://github.com/spotify/dockerfile-mode
(autoload 'dockerfile-mode "dockerfile-mode"
  "Major mode for editing Docker files")
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;;; go-mode https://github.com/dominikh/go-mode.el
;;; http://dominik.honnef.co/posts/2013/03/writing_go_in_emacs/
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook (lambda ()
			  (local-set-key (kbd "C-c i") `go-goto-imports)
			  (local-set-key (kbd "C-c C-r")
					 'go-remove-unused-imports)))
(add-to-list 'exec-path (concat (getenv "HOME") "/Source/go/bin"))

;;; From MS Copilot
(defun open-default-file ()
  "Open a default file when Emacs starts without any specified file."
  (when (and (not (buffer-file-name))
             (equal (buffer-name) "*scratch*"))
    (find-file "~/Library/Application Support/Aquamacs Emacs/scratch buffer")))

(add-hook 'emacs-startup-hook 'open-default-file)
