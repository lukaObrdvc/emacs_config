;; Emacs 29.3_2


;; @TODO

;; beginning-of-visual-line is decent with wrapping lines...??

;; multiple cursors?
;; C-{ will auto scope and stuff?
;; auto reindent when yanking ??
;; guard (automatic?)
;; add horizontal whitespace up to point in a region
;; make an emacs function that aligns the all = with the horizontally furthest one



;; @CONFIGS

(setq load-path (cons "w:/Emacs/projects" load-path))
;; this is the default project
(defvar build-script-directory "w:/Projects/vgengine/code")
(defvar build-script-name "build")
(defvar project-name "vgengine")
(defvar code-file-extensions "*.h *.c")


(add-to-list 'load-path "w:/Emacs/packages")
(require 'wgrep)

(add-to-list 'custom-theme-load-path "w:Emacs/themes")
(load-theme 'moonrocks t)
;;(load-theme 'desert-sapphire t)

;;(set-face-attribute 'default nil :font "JetBrains Mono Regular-11")
;;(set-face-attribute 'default nil :font "Inconsolata-g-11")
;;(set-face-attribute 'default nil :font "Liberation Mono-11")
;;(set-face-attribute 'default nil :font "Cascadia Mono-11")
;;(set-face-attribute 'default nil :font "Hack-11")
;;(set-face-attribute 'default nil :font "DejaVu Sans Mono-11")
(set-face-attribute 'default nil :font "Consolas-12")
;;(set-face-attribute 'default nil :font "Iosevka-12")
;; juliamono...

(setq inhibit-splash-screen t)
(setq visible-bell nil)
(set-message-beep 'silent)
(set-default 'truncate-lines t) ;; disables wrapping

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)     ;; C

(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode -1)
(blink-cursor-mode -1)
(show-paren-mode 1)
(abbrev-mode 1)
(setq blink-matching-paren t)

(require 'ido)
(ido-mode t)
(ido-everywhere t)
(fido-mode t)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq undo-limit 100000)
(setq undo-strong-limit 200000)

(push '("\\*completions\\*"
        (display-buffer-use-some-window display-buffer-pop-up-window)
        (inhibit-same-window . t))
      display-buffer-alist)

(defvar __MyKeymap (make-sparse-keymap))
(define-minor-mode __MyMode
  "My modal mode"
  :keymap __MyKeymap)



;; @COMMANDS

;; rename certain commands to prefix with :  , also pascal case?


(defun __update-cursor ()
  (setq cursor-type (if __MyMode 'box 'bar))
  )
(add-hook 'post-command-hook #'__update-cursor)

(defun __ToggleInsert ()
  (interactive)
  (unless (not __MyMode)
    (setq __MyMode nil)
    (setq cursor-type 'bar)
    )
  )

(defun __ToggleCommand ()
  (interactive)
  (unless __MyMode
    (setq __MyMode t)
    (setq cursor-type 'box)
    )
  )

(defun __delete-word (arg)
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun __backward-delete-word (arg)
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun __duplicate-line ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (move-beginning-of-line 1)
      (kill-line)
      (yank)
      (newline)
      (yank))
    (forward-line 1)
    (move-to-column col))
  )

(defun __clean-system-buffers ()
  (interactive)
  (dolist (buf (buffer-list))
    (when (string-match-p "\\*.*\\*" (buffer-name buf))
      (kill-buffer buf)))
  )

;; Inhibit message when there is something to save ??
(defun __save-all ()   ;; change to :save ??
  (interactive)
  (save-some-buffers t)
  )
(run-with-timer 0 30 '__save-all)

(defun __init-project-name (arg1)
  (interactive "sChoose project name: ")
  (setq project-name arg1)
  )

(defun __init-build-script-path (arg1)
  (interactive "sChoose build script path: project-name/")
  (setq build-script-directory (concat "w:/Projects/" project-name "/" arg1))
  )

(defun __init-build-script-name (arg1)
  (interactive "sChoose build script name: ")
  (setq build-script-name arg1)
  )

(defun __init-code-file-extensions (arg1)
  (interactive "sLanguage file extensions (ex. \"*.h *.c\"): ")
  (setq code-file-extensions arg1)
  )

(defun __init-stub (arg1)
  (interactive "sChoose project stub (\"none\" for no stub): ")
  (copy-directory (concat "w:/Stubs/" arg1) (concat "w:/Projects/" project-name) nil nil t)
  )

(defun :project-new ()
  (interactive)
  (call-interactively '__init-project-name)
  (call-interactively '__init-build-script-path)
  (call-interactively '__init-build-script-name)
  (call-interactively '__init-code-file-extensions)
  (call-interactively '__init-stub)
  (find-file (concat "w:/Emacs/projects/" project-name ".el"))
  (insert (concat "(setq project-name \"" project-name "\")"))
  (electric-newline-and-maybe-indent)
  (insert (concat "(setq build-script-name \"" build-script-name "\")"))
  (electric-newline-and-maybe-indent)
  (insert (concat "(setq build-script-directory \"" build-script-directory "\")"))
  (electric-newline-and-maybe-indent)
  (insert (concat "(setq code-file-extensions \"" code-file-extensions "\")"))
  (save-buffer)
  (cd (concat "w:/Projects/" project-name))
  (previous-buffer)
  )

(defun :project-switch (arg1)
  (interactive "sChange to project: ")
  (load (concat arg1 ".el"))
  (cd (concat "w:/Projects/" project-name))
  (if (string= arg1 "quick") (find-file "quick.c"))
  )

;; git init repo ?
;; git pull ?
(defun :git-push (arg1)
  (interactive "sCommit message: ")
  (__save-all)
  (shell-command "git add .")
  (shell-command (format "git commit -m \"%s\"" arg1))
  (shell-command "git push origin main")
  )

(defun :quick-run ()
  (interactive)
  (kill-buffer "*scratch*")
  (if (= (count-windows) 1) (split-window-right))
  (other-window 1)
  (scratch-buffer)
  (shell-command "w:/quick" "*scratch*")
  (other-window -1)
  )

;; automatic :git-push
(defun :quick-save (arg1)
  (interactive "sChoose name for quick: ")
  (__save-all)
  (copy-file "w:/Projects/quick/quick.c" (concat "w:/Quicks/src/" arg1 ".c"))
  (copy-file "w:/Projects/quick/exe/quick.exe" (concat "w:/Quicks/exe/" arg1 ".exe"))
  )

(defun :quick-load (arg1)
  (interactive "sName of quick to load: ")
  (copy-file (concat "w:/Quicks/src/" arg1 ".c") "w:/Projects/quick/quick.c" t)
  )

(defun :config ()
  (interactive)
  (find-file "w:/Emacs/init.el")
  )

;; automatic, async, better xref window ...?
(defun :tags-make ()
  (interactive)
  (__save-all)
  (cd (concat "w:/Projects/" project-name "/"))
  (shell-command "ctags -e -R")
  (cd (file-name-directory buffer-file-name))
  )

(defun __grep (arg1)
  (interactive "sgrep findstr: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd (concat "w:/Projects/" project-name "/"))
  (grep (format "findstr -s -n -i -r \"%s\" %s" arg1 code-file-extensions))
  (cd (file-name-directory buffer-file-name))
  )

(defun __grep-current-buffer-only (arg1)
  (interactive "sgrep findstr: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (grep (format "findstr -s -n -i -r \"%s\" %s" arg1 (buffer-file-name)))
  )

;; other-window 1 and -1 for these.... idk how to make it work....
(defun __compile ()
  (interactive)
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd build-script-directory)
  (compile build-script-name)
  (cd (file-name-directory buffer-file-name))
  )


;; @KEYBINDINGS


;; unbind in modal for shift + letter ??

(global-set-key (kbd "<f19>") #'__ToggleCommand)
(global-set-key (kbd "<tab>") 'dabbrev-expand)

(define-key __MyKeymap (kbd "i") 'previous-line)
(define-key __MyKeymap (kbd "k") 'next-line)
(define-key __MyKeymap (kbd "j") 'backward-char)
(define-key __MyKeymap (kbd "l") 'forward-char)
(define-key __MyKeymap (kbd "a") 'move-beginning-of-line)
(define-key __MyKeymap (kbd "e") 'move-end-of-line)
(define-key __MyKeymap (kbd "d") 'delete-char)
(define-key __MyKeymap (kbd "u") 'isearch-forward)
(define-key __MyKeymap (kbd "U") 'isearch-backward)
(define-key __MyKeymap (kbd "w") 'yank)
(define-key __MyKeymap (kbd "t") 'undo)
(define-key __MyKeymap (kbd "c") 'kill-region)
(define-key __MyKeymap (kbd "r") 'kill-line)
(define-key __MyKeymap (kbd "g") 'recenter-top-bottom)
;;(define-key __MyKeymap (kbd "g") 'keyboard-quit)
(define-key __MyKeymap (kbd "I") #'(lambda () (interactive) (move-to-window-line 0) (previous-line)))
(define-key __MyKeymap (kbd "K") #'(lambda () (interactive) (move-to-window-line -1) (next-line)))
(define-key __MyKeymap (kbd "s") 'newline)
(define-key __MyKeymap (kbd "<tab>") 'indent-for-tab-command)
(define-key __MyKeymap (kbd "v") 'set-mark-command)
(define-key __MyKeymap (kbd "z") 'execute-extended-command)
(define-key __MyKeymap (kbd "J") 'left-word)
(define-key __MyKeymap (kbd "L") 'right-word)
(define-key __MyKeymap (kbd "m") 'replace-string)
(define-key __MyKeymap (kbd "q") 'other-window)
(define-key __MyKeymap (kbd "b") (kbd "C-u C-SPC")) ;; pop mark
(define-key __MyKeymap (kbd "h") 'switch-to-buffer)
(define-key __MyKeymap (kbd "y") 'find-file)
(define-key __MyKeymap (kbd "f") 'backward-delete-char)
(define-key __MyKeymap (kbd "o") 'imenu)
(define-key __MyKeymap (kbd "x i") 'beginning-of-buffer)
(define-key __MyKeymap (kbd "x k") 'end-of-buffer)
;; (define-key __MyKeymap (kbd "D") 'kill-word)
;; (define-key __MyKeymap (kbd "F") 'backward-kill-word)
(define-key __MyKeymap (kbd "V") 'rectangle-mark-mode)
(define-key __MyKeymap (kbd "M") 'string-insert-rectangle)
(define-key __MyKeymap (kbd ";") 'comment-line)
(define-key __MyKeymap (kbd "S") 'open-line)
(define-key __MyKeymap (kbd "C") 'kill-ring-save)
(define-key __MyKeymap (kbd "=") 'quick-calc)
(define-key __MyKeymap (kbd "n") 'next-error)
(define-key __MyKeymap (kbd "N") 'previous-error)
(define-key __MyKeymap (kbd "SPC") #'__ToggleInsert)
(define-key __MyKeymap (kbd "`") '__clean-system-buffers)
(define-key __MyKeymap (kbd "R") '__duplicate-line)
(define-key __MyKeymap (kbd "D") #'__delete-word)
(define-key __MyKeymap (kbd "F") #'__backward-delete-word)

(define-key __MyKeymap (kbd "x c") '__compile)
(define-key __MyKeymap (kbd "x h e") 'eval-last-sexp) 
(define-key __MyKeymap (kbd "x h d f") 'describe-function)
(define-key __MyKeymap (kbd "x h d v") 'describe-variable)
(define-key __MyKeymap (kbd "x h d k") 'describe-key)
(define-key __MyKeymap (kbd "x h s") 'where-is)
(define-key __MyKeymap (kbd "x m c") ':config)
(define-key __MyKeymap (kbd "x m t") ':tags-make)
(define-key __MyKeymap (kbd "x m s") 'scratch-buffer)
(define-key __MyKeymap (kbd "x e q") 'query-replace)
(define-key __MyKeymap (kbd "x w d") 'split-window-below)
(define-key __MyKeymap (kbd "x w r") 'split-window-right)
(define-key __MyKeymap (kbd "x w c") 'delete-other-windows)
(define-key __MyKeymap (kbd "x w q") 'delete-window)
(define-key __MyKeymap (kbd "x w s") #'(lambda () (interactive) (delete-other-windows)(split-window-right)))
(define-key __MyKeymap (kbd "x g g") '__grep)
(define-key __MyKeymap (kbd "x g b") '__grep-current-buffer-only)
(define-key __MyKeymap (kbd "x f g p") ':git-push)
(define-key __MyKeymap (kbd "x q r") ':quick-run)
(define-key __MyKeymap (kbd "x q s") ':quick-save)
(define-key __MyKeymap (kbd "x q l") ':quick-load)
(define-key __MyKeymap (kbd "x p n") ':project-new)
(define-key __MyKeymap (kbd "x p s") ':project-switch)


;; run project...

;; delete-file
;; rename-file          +refactoring
;; make-directory
;; rename-directory
;; delete-directory
;; ido-list-directory


;; if you use this on a non-grep buffer, do M-x read-only-mode
;;(global-set-key (kbd "C-S-w") 'wgrep-finish-edit) ;; saves wgrep changes
;;(global-set-key (kbd "C-w") (kbd "C-c C-p")) ;; turns wgrep on

;; f3 - start macro
;; f4 - end macro, replay last macro


;;(define-key c-mode-map (kbd "M-e") nil)



;; @PREVIOUS KEYBINDINGS

;;(global-set-key (kbd "C-M-f") 'project-find-file)
;;(global-set-key (kbd "M-t") 'pop-global-mark)
;;(global-set-key (kbd "C-<prior>") 'beginning-of-defun)
;;(global-set-key (kbd "C-<next>") 'end-of-defun)
;;(global-set-key (kbd "C-M-<left>") 'backward-list)
;;(global-set-key (kbd "C-M-<right>") 'forward-list)
;;(global-set-key (kbd "C-M-<up>") 'backward-up-list)
;;(global-set-key (kbd "C-M-<down>") 'down-list)
;;(global-set-key (kbd "<home>") 'insert-parentheses)
;;(global-set-key (kbd "<end>") 'delete-pair)


;; @INFO


;; flyspell-mode .................
;; upcase-region
;; scratch-buffer
;; ? on command in minibuffer to show possible completions
;; SPC for M-f autocompletes
;; you can change font size with mouse wheel, and in the buffer border you can see offset from original
;; ???? ~ back-to-indentation
;; M-g g ~ goto-line
;; occur-rename-buffer is basically wgrep

;; from old __save-all (although the let and inhibit-message doesn't work...)
;; (setq current-prefix-arg '(!))
;; (let ((inhibit-message t)) (call-interactively 'save-some-buffers))

