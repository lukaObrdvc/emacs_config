;; clothes
;; take out laundry
;; do laundry
;; yoga

;; worklogging (life logging/journaling) like jblow ....??


;; delete-file
;; rename-file          +refactoring
;; make-directory
;; rename-directory
;; delete-directory
;; ido-list-directory


;; emacs 29.3_2

(global-set-key (kbd "M-H e") 'eval-last-sexp) 
(global-set-key (kbd "M-H d f") 'describe-function)
(global-set-key (kbd "M-H d v") 'describe-variable)
(global-set-key (kbd "M-H d k") 'describe-key)
(global-set-key (kbd "M-H s") 'where-is)



(setq load-path (cons "w:/Emacs/projects" load-path))
;; this is the default project
(defvar build-script-directory "w:/Projects/vgengine/code")
(defvar build-script-name "build")
(defvar project-name "vgengine")
(defvar code-file-extensions "*.h *.c")

(add-to-list 'load-path "w:/Emacs/packages")
(require 'wgrep)
(setq wgrep-auto-save-buffer t)

(add-to-list 'custom-theme-load-path "w:Emacs/themes")
(load-theme 'desert-sapphire t)
(set-face-attribute 'default nil :font "Courier New-12")
(set-face-attribute 'default nil :font "Office Code Pro-12")

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
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(show-paren-mode 1)
(setq blink-matching-paren t)

(abbrev-mode 1)
(cua-mode 1)
(global-hl-line-mode 1)

(require 'ido)
(ido-mode t)
(ido-everywhere t)
(fido-mode t)

(setq redisplay-dont-pause t)
(setq scroll-margin 10)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq scroll-preserve-screen-position 1)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq undo-limit 100000)
(setq undo-strong-limit 200000)

;; M-x ~ minibuffer
;; C-a ~ beginning-of-line
;; C-e ~ end-of-line
;; C-d ~ delete-right-char (M=word)
;; <backspace> ~ delete-left-char (M=word)
;; M-\ ~ delete all horizontal space
;; C-s ~ search-forward
;; C-r ~ search-backward
;; C-g ~ quit
;; C-SPC ~ set-mark
;; M-. ~ jump to definition
;; cua
;; M-y ~ yank-from-kill-ring (but what if I use a prefix argument..?)
;; f3 ~ start macro recording
;; f4 ~ end macro recording || replay last recorded macro
;; M-< ~ begin of document
;; M-> ~ end of document

;; :project-switch 
;; :project-new 
;; :git-push
;; :quick-save 
;; :quick-load 
;; :quick-run 
;; :config 

(global-unset-key (kbd "C-k"))
(global-unset-key (kbd "M-k"))
(global-unset-key (kbd "C-<delete>"))
(global-unset-key (kbd "M-DEL"))
(global-unset-key (kbd "C-q"))
(global-unset-key (kbd "C-w"))
(global-unset-key (kbd "C-W"))
(global-unset-key (kbd "C-M-W"))

(global-set-key (kbd "M-f") 'find-file)
(global-set-key (kbd "C-M-f") 'project-find-file)
(global-set-key (kbd "M-b") 'switch-to-buffer)
(global-set-key (kbd "M-w") 'other-window)
(global-set-key (kbd "<escape>") 'delete-other-windows) ;; also remove emacs buffers ...?
(global-set-key (kbd "M-s") 'split-window-right)
(global-set-key (kbd "C-=") 'quick-calc)

(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)
(global-set-key (kbd "M-r") (kbd "C-u C-SPC")) ;; jump to previous mark
(global-set-key (kbd "M-t") 'pop-global-mark)
(global-set-key (kbd "C-<prior>") 'beginning-of-defun)
(global-set-key (kbd "C-<next>") 'end-of-defun)
(global-set-key (kbd "C-M-<left>") 'backward-list)
(global-set-key (kbd "C-M-<right>") 'forward-list)
(global-set-key (kbd "C-M-<up>") 'backward-up-list)
(global-set-key (kbd "C-M-<down>") 'down-list)

(global-set-key (kbd "<delete>") 'kill-line)
;;(global-set-key (kbd "M-[") 'insert-parentheses)
;;(global-set-key (kbd "M-]") 'delete-pair)
(global-set-key (kbd "<home>") 'insert-parentheses)
(global-set-key (kbd "<end>") 'delete-pair)
(global-set-key (kbd "<tab>") 'dabbrev-expand)
(global-set-key (kbd "C-<tab>") 'indent-for-tab-command)
(global-set-key (kbd "M-Q") 'query-replace)                                 ;; remap?? M-O
(global-set-key (kbd "M-q") 'replace-string)                                ;; remap?? M-o
(global-set-key (kbd "C-/") 'comment-line)
(global-set-key (kbd "M-SPC") 'rectangle-mark-mode)
(global-set-key (kbd "S-SPC") 'string-insert-rectangle)

;; saves wgrep changes
(global-set-key (kbd "C-S-w") 'wgrep-finish-edit) ;; if you use this on a non-grep buffer, do M-x read-only-mode
;; turns wgrep on
(global-set-key (kbd "C-w") (kbd "C-c C-p"))

;; change to :save ??
;; inhibit message?
(defun __save-all ()
  (interactive)
  (setq current-prefix-arg '(!))
  (call-interactively 'save-some-buffers)
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

(defun :quick-save (arg1)
  (interactive "sChoose name for quick: ")
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

(defun __grep (arg1)
  (interactive "sgrep findstr: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd (concat "w:/Projects/" project-name "/"))
  (grep (format "findstr -s -n -i -r \"%s\" %s" arg1 code-file-extensions))
  (cd (file-name-directory buffer-file-name))
  )
(global-set-key (kbd "`") '__grep)

(defun __grep-current-buffer-only (arg1)
  (interactive "sgrep findstr: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (grep (format "findstr -s -n -i -r \"%s\" %s" arg1 (buffer-file-name)))
  )
(global-set-key (kbd "M-`") '__grep-current-buffer-only)

;; other-window 1 and -1 for these.... idk how to make it work....
(defun __compile ()
  (interactive)
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd build-script-directory)
  (compile build-script-name)
  (cd (file-name-directory buffer-file-name))
  )
(global-set-key (kbd "M-m") '__compile)

(defun __bigmove-up ()
  (interactive)
  (previous-line)
  (previous-line)
  (previous-line)
  (previous-line)
  (previous-line)
  )
(global-set-key (kbd "C-<up>") '__bigmove-up)

(defun __bigmove-down ()
  (interactive)
  (next-line)
  (next-line)
  (next-line)
  (next-line)
  (next-line)
  )
(global-set-key (kbd "C-<down>") '__bigmove-down)

(defun __hugemove-up ()
  (interactive)
  (__bigmove-up)
  (__bigmove-up)
  (__bigmove-up)
  (previous-line)
  (previous-line)
  (previous-line)
  (previous-line)
  )
(global-set-key (kbd "C-S-<up>") '__hugemove-up)

(defun __hugemove-down ()
  (interactive)
  (__bigmove-down)
  (__bigmove-down)
  (__bigmove-down)
  (next-line)
  (next-line)
  (next-line)
  (next-line)
  )
(global-set-key (kbd "C-S-<down>") '__hugemove-down)

;; @@INFO

;; declare functions from source into header
;; guard (automatic?)
;; greping with regexp??????
;; add horizontal whitespace up to point in a region

;; scratch-buffer
;; ? on command in minibuffer to show possible completions
;; SPC for M-f autocompletes

;;                                                           ???? ~ back-to-indentation

;;                                                           C-p ~ previous-line (M=word)
;;                                                           C-n ~ next-line (M=word)
;;                                                           C-f ~ right-char (M=word)
;;                                                           C-b ~ left-char (M=word)
;;                                                           M-g g ~ goto-line
;;                                                           C-v ~ scroll-down
;;                                                           M-v ~ scroll-up
;;                                                           <tab> ~ auto-indent
;;                                                           C-l ~ center-on-point


