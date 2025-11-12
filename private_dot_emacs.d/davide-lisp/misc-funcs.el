;; -*- lexical-binding: t; -*-

(provide 'misc-funcs)

;;;----------------------------------------------------------------
;;;				misc functions
;;;----------------------------------------------------------------
(defun de-revert-buffer ()
  "Function to revert the buffer without asking questions"
  (interactive)
  (let ((pos (point)))
    (revert-buffer t t)
    (goto-char (min pos (point-max)))
    ))

(defun scroll-half-screen-up ()
  "scroll the screen up by half its height"
  (interactive)
  (scroll-up (/ (window-height) 2)))

(defun scroll-half-screen-down ()
  "scroll the screen down by half its height"
  (interactive)
  (scroll-down (/ (window-height) 2)))

(defun up-one-line (count)
  "Scroll up one line"
  (interactive "p")
  (scroll-up count))

(defun down-one-line (count)
  "Scroll up one line"
  (interactive "p")
  (scroll-down count))

(defun line-to-top ()
  "function to reposition the line that point is on to the top of the window"
  (interactive)
  (recenter 1))

(defun line-to-bottom ()
  "function to position the line that point is on to the bottom of the window"
  (interactive)
  (recenter (- (window-height) 2)))

(defun home-point ()
  "reposition point to the first line in the window"
  (interactive)
  (move-to-window-line 0))

(defun other-home-point ()
  "repostion to last text line in current window"
  (interactive)
  (move-to-window-line (- (window-height) 2)))

(defun toggle-buffers ()
  "Execute 'switch-to-buffer with a nil argument"
  (interactive)
  (switch-to-buffer nil))

(defun cycle-buffers ()
  "Select the next buffer in the buffer list by burying current buffre."
  (interactive)
  (bury-buffer))

(defun cycle-buffers-reverse ()
  "Selete the buffer at the bottom of the buffer list."
  (interactive)
  (switch-to-buffer (car (nreverse (buffer-list)))))

(defun view-current-buffer ()
  "Put the current buffer into view-mode."
  (interactive)
  (view-buffer (current-buffer)))

;;; Like mouse-yank-at-click, but don't move point before doing the yank.
(defun mouse-yank-at-point (click arg)
  "Insert the last stretch of killed text at the current point.
Prefix arguments are interpreted as with \\[yank]."
  (interactive "e\nP")
  (setq this-command 'yank)
  (yank arg))

;;;
(defun kill-buffer-and-delete-window ()
  "Kill the current buffer and delete the window it is displayed it."
  (interactive)
  (kill-buffer (current-buffer))
  (delete-window))

;;;
;;; Get the name of the current frame.
(defun frame-name (&optional frame)
  "Get the name of FRAME.

If FRAME is not supplied, it defaults to current frame."
  (cdr (assq 'name (frame-parameters frame))))

(defalias 'get-frame-name 'frame-name)

(defun show-file-name ()
  "Evaluate the buffer-file-name function to show name of file being visited."
  (interactive)
  (message (format "%s" (print (buffer-file-name)))))

(defun reposition-defun (&optional arg)
  "Position the beginning of the defun at the top of the screen."
  (interactive "p")
  (and arg (< arg 0) (forward-char 1))
  (save-excursion
    (and (re-search-backward "^\\s(" nil 'move (or arg 1))
         (progn
           (recenter 0)
           (beginning-of-line)
           t))))

;;; A function to change the tab-width variable
(defun change-tab-width-to-4 ()
  "Change the value of tab-width to 4."
  (interactive)
  (setq tab-width 4)
  (redraw-frame (selected-frame)))

;;; a function that will comment a region of lisp code, putting ";;;" at the
;;; beginning of each line
(defun lisp-comment-region (start end)
  (interactive "*r")
  (save-excursion
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (not (eobp))
      (insert ";;; ")
      (beginning-of-line)
      (forward-line 1))
    (widen)))

;;; Subject: Re: Parenthesis matching when positioned over curser 
;;; Date: Fri, 10 Mar 89 09:31:47 -0500
;;; From: Stephen Gildea <gildea@bbn.com>
;;; 
;;; I've seen two paren-matching routines posted here, and neither used
;;; the obvious way to test for a paren.
;;; 
;;; Simple test for an open paren:	(looking-at "\\s(")
;;; Simple test for a close paren:	(looking-at "\\s)")
;;; 
;;; Also, you might find the following one-liner does what you want:

(defun interactive-blink-matching-open ()
  "Move cursor momentarily to the beginning of the sexp before point."
  (interactive)
  (let ((blink-matching-paren t))
    (blink-matching-open)))

;;; command to quit a dired session...
(defun dired-delete-and-exit ()
  "Quit editing this directory."
  (interactive)
  (dired-do-delete)
;;;  (dired-do-flagged-delete)
  (kill-buffer (current-buffer)))

; A little gadget to delete a file without asking.
; from: phs@lifia.imag.fr (Philippe Schnoebelen)
(defun dired-delete-this-file ()
  "In dired, delete the file named on this line."
  (interactive)
  (let ((buffer-read-only nil)
	(fname (dired-get-filename)))
    (if (not (y-or-n-p (format "Delete file %s " fname)))
	(message "OK, I won't.")
	;; else, do it !
      (delete-file fname)
      (delete-region (progn (beginning-of-line) (point))
		     (progn (forward-line 1) (point)))
      (message "Done"))))

(defun dired-find-file-read-only ()
  "In dired, visit the file or directory named on this line."
  (interactive)
  (find-file-read-only (dired-get-filename)))

;;;From Mark D. Baushke, mdb@ESD.3Com.COM
(defun insert-box (start end text)
  "Insert a text prefix at a column in all the lines in the region.
   Called from a program, takes three arguments, START, END, and TEXT.
   The column is taken from that of START.
   The rough inverse of this function is kill-rectangle."
  (interactive "r\nsText To Insert: ")
  (save-excursion
    (let (cc)
      ;; the point-marker stuff is needed to keep the edits from changing
      ;; where end is
      (goto-char end)
      (setq end (point-marker))
      (goto-char start)
      (setq cc  (current-column))
      (while (and
	      (<= (point) end) ;; modified 2/2/88 and again 4/20/98 to do the
	      (< (point) (point-max)))     ;; last line in the region correctly.
	;; I should here check for tab chars
	(insert text)
	(forward-line 1)
	(move-to-column cc 'force))
      (move-marker end nil))))

(defun insert-suffix (start end text)
  "Insert a text suffix at the end in all the lines in the region.
   Called from a program, takes three arguments, START, END, and TEXT.
   The column is taken from that of START."
  (interactive "r\nsText To Insert: ")
  (save-excursion
    (let (cc)
      ;; the point-marker stuff is needed to keep the edits from changing
      ;; where end is
      (goto-char end)
      (setq end (point-marker))
      (goto-char start)
      (end-of-line)	
      (while (< (point) end);; modified 2/2/88
	;; I should here check for tab chars
	(insert text)
	(forward-line 1)
	(end-of-line)	
	)
      (move-marker end nil))))

;;; From: sk@thp.uni-koeln.de
;;; Newsgroups: gnu.emacs.sources
;;; Subject: More useful C-x = and ESC = commands
;;; Date: 2 Nov 90 12:22:10 GMT
;;; 
;;; C-x = (what-cursor-position) should also display the line number, and
;;; ESC = (count-lines-region) should not only count lines, but words and
;;; characters as well:
;;; 
(define-key esc-map "=" 'count-region)
(defun count-region (start end)
  "Count lines, words and characters in region."
  (interactive "r")
  (let ((l (count-lines start end))
	(w (count-words start end))
	(c (- end start)))
    (message "Region has %d line%s, %d word%s and %d character%s."
	     l (if (= 1 l) "" "s")
	     w (if (= 1 w) "" "s")
	     c (if (= 1 c) "" "s"))))

(defun count-words (start end)
  "Return number of words between START and END."
  (let ((count 0))
    (save-excursion
      (save-restriction
	(narrow-to-region start end)
	(goto-char (point-min))
	(while (forward-word 1)
	  (setq count (1+ count)))))
    count))

(define-key ctl-x-map "=" 'what-cursor-position-and-line)
(defun what-cursor-position-and-line ()
  ;; So you don't need what-line any longer.
  "Print info on cursor position (on screen and within buffer)."
  (interactive)
  (let* ((char (following-char))
	 (beg (point-min))
	 (end (point-max))
         (pos (point))
	 (total (buffer-size))
	 (percent (if (> total 50000)
		      ;; Avoid overflow from multiplying by 100!
		      (/ (+ (/ total 200) (1- pos)) (max (/ total 100) 1))
		    (/ (+ (/ total 2) (* 100 (1- pos))) (max total 1))))
	 (hscroll (if (= (window-hscroll) 0)
		      ""
		    (format " Hscroll=%d" (window-hscroll))))
	 (col (current-column))
	 (line (save-restriction
		 (widen)
		 (save-excursion
		   (beginning-of-line)
		   (1+ (count-lines 1 (point)))))))
    (if (= pos end)
	(if (or (/= beg 1) (/= end (1+ total)))
	    (message "point=%d of %d(%d%%) <%d - %d>  line %d column %d %s"
		     pos total percent beg end line col hscroll)
	  (message "point=%d of %d(%d%%)  line %d column %d %s"
		   pos total percent line col hscroll))
      (if (or (/= beg 1) (/= end (1+ total)))
	  (message "Char: %s (0%o)  point=%d of %d(%d%%) <%d - %d>  line %d column %d %s"
		   (single-key-description char) char pos total percent beg end line col hscroll)
	(message "Char: %s (0%o)  point=%d of %d(%d%%)  line %d column %d %s"
		 (single-key-description char) char pos total percent line col hscroll)))))


;;;Enjoy,
;;;Roland McGrath
;; Enable yourself, cretin.
(setq disabled-command-hook 'enable-me)

(defun enable-me (&rest args)
  "Called when a disabled command is executed.
Enable it and reexecute it."
  (put this-command 'disabled nil)
  (message "You typed %s.  %s was disabled.  It ain't no more."
	   (key-description (this-command-keys)) this-command)
  (sit-for 0)
  (call-interactively this-command))


;;; From: Roland McGrath <mcgrath%tully.Berkeley.EDU@ginger.berkeley.edu>
;;; To: info-gnu-emacs@prep.ai.mit.edu
;;; Subject: A useful compilation function
;;; Date: Wed, 18 May 88 21:51:11 PDT

;;; >From my .emacs:  I find this function VERY useful for compilations.
;;; Bound to a key (I use C-x c), it quickly recompiles whatever you were
;;; last compiling.  Another hint: If you do
;;; 	(make-variable-buffer-local 'compile-command)
;;; in your .emacs, commands for M-x compile will be local to each buffer,
;;; so you can compile two separate things at once.  I found this very
;;; useful when trying to do a test of Make with M-x in one buffer and
;;; recompiling Make after fixing bugs in another buffer.  Just hit C-x o
;;; C-x c and it does it all!
;;; So you will never have to type M-x compile again, C-x c will prompt
;;; you for the compilation command line if you haven't run C-x c in the
;;; current buffer before.

;; Make compile-command buffer-local
(make-variable-buffer-local 'compile-command)

;; C-x c compiles with the same commands as last M-x compile in this buffer
(defvar compiled-in-this-buffer
  "T if \\[compile-with-same-commands] has been run in this buffer."
  nil)
(defun compile-with-same-commands ()
  "Run \\[compile] with the same commands as the
last \\[compile] or \\[compile-with-same-commands]."
  (interactive)
  (make-variable-buffer-local 'compiled-in-this-buffer)
  (if compiled-in-this-buffer
      (compile compile-command)
    (call-interactively 'compile))
  (setq compiled-in-this-buffer t))

; moved where it belongs (global-set-key "c" 'compile-with-same-commands)

;;; From: think!compass!worley@eddie.mit.edu (Dale Worley)
;;; To: info-gnu-emacs@eddie.mit.edu
;;; Subject: Function for saving the results of a help request
;;; Date: Mon, 17 Oct 88 15:21:47 EDT
(defun save-help ()
  "save-help will rename the *Help* buffer
*Help<1>*, *Help<2>*, etc., so the information won't get clobbered by
further help requests."
  (interactive)
  (save-excursion
    (let ((i 1) 
	  (buffer (get-buffer "*Help*"))
	  name)
      (if (not buffer)
	  (ding)
	(while
	    (progn
	      (setq name (concat "*Help<" (int-to-string i) ">*"))
	      (get-buffer name))
	  (setq i (1+ i)))
	(set-buffer buffer)
	(rename-buffer name)
	(message (concat "Help buffer renamed " name))))))

(defun shell-command-on-buffer (command &optional flag)
  "Execute string COMMAND in inferior shell with buffer as input;
display output (if any) in temp buffer;
Prefix arg means replace the buffer with it."
  (interactive "sShell command (on buffer): \nP")
  (if flag
      (progn
	(goto-char (point-min))
	(push-mark (point-max))))
  (shell-command-on-region (point-min) (point-max) command flag t))

;;; Another scrolling function: I almost never need to refresh the screen with
;;; ^L.  I don't suffer from noisy lines and there don't seem to be any
;;; redisplay bugs.  However, the ability to move the current line around on
;;; the screen is really useful.  Therefore, I bind this to ^L, and put
;;; recenter on ESC-^L. (lord+@andrew.cmu.edu Tom Lord)
(defun recenter-sans-bletcherous-redraw (prefix)
  "Recenter without redrawing."
  (interactive "p")
  (if current-prefix-arg
      (recenter prefix)
    (let ((current-prefix-arg '(4)))    ;hackety hack hack hack
      (recenter current-prefix-arg))))

;;; other-info.el -- start info in a different directory
;;; Mark Ardis, SEI, 6/12/89  maa@sei.cmu.edu
;;; The following function is for those who want to hack their own
;;; info-nodes and install them in their own directories.
;;;(require 'info)

(defun other-info (file)
  "Go to a node called 'top' in the Info directory node found in file."
  (interactive "fInfo file (with 'top' node)? ")
  (Info-find-node file "top"))


;;; Comment C Region
;;; Written by Steve Byrne
;;;
;;; This file is not a part of GNU Emacs.
;;;
;;; This code free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 1, or (at your option)
;;; any later version.
;;;
;;; This code is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
(defun comment-c-region (start end arg &optional ifdef)
  "Reversably comment out the region between START and END.
With an argument, undoes the commenting around the region."
  (interactive "r
p")
  (let ((date (current-time-string)))
    (if (and (= arg 1) (null ifdef))
	(setq ifdef (read-string "#ifdef ")))
    (save-excursion
      (save-restriction
	(narrow-to-region start end)
	(beginning-of-buffer)
	(if (= arg 1)
	    (insert-string (format "#ifdef %s /* %s */\n" ifdef date))
	  (kill-line 1))
	(while (not (eobp))
	  (if (= arg 1)
	      (insert-string "/**/")
	    (if (looking-at (regexp-quote "/**/"))
		(delete-char 4)
	      (if (looking-at "#endif ")
		  (progn (kill-line 1)
			 (end-of-buffer)))))
	  (forward-line 1))
	(if (= arg 1)
	    (insert-string (format "#endif /* %s %s */\n" ifdef date)))
      ))
    (forward-line 1)
    ))
