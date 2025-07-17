;; Emacs 29.3_2

;; integrated shell????

;; virtualized directories for Projects and Emacs folders....

;; @CONFIGS

(set-face-attribute 'default nil :font "JetBrains Mono Regular-14")
;; (set-face-attribute 'default nil :font "Inconsolata-g-13")
;; (set-face-attribute 'default nil :font "Liberation Mono-14")
;; (set-face-attribute 'default nil :font "Consolas-14")

(set-face-attribute 'default nil :background "#f4f4ea")
(set-face-attribute 'font-lock-function-name-face nil :foreground "Black") ;; Blue3
(set-face-attribute 'font-lock-variable-name-face nil :foreground "Black")
(set-face-attribute 'font-lock-constant-face nil :foreground "Black")
(set-face-attribute 'font-lock-builtin-face nil :foreground "Black")
(set-face-attribute 'font-lock-keyword-face nil :foreground "Blue3")
(set-face-attribute 'font-lock-preprocessor-face nil :foreground "Blue3")
(set-face-attribute 'font-lock-type-face nil :foreground "brown3") ;; orangered, brown, firebrick, chocolate
(set-face-attribute 'font-lock-comment-face nil :foreground "ForestGreen")
(set-face-attribute 'font-lock-string-face nil :foreground "cyan4")
(eval-after-load 'dired
  '(set-face-attribute 'dired-directory nil :foreground "brown3" :weight 'bold))
;; set-face-attribute 'dired-marked nil :background "#444" :foreground "yellow")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode -1)
(blink-cursor-mode -1)
(show-paren-mode 1)
(column-number-mode 1)
(global-auto-revert-mode 1)
(abbrev-mode 1)

(set-message-beep 'silent)
(set-default 'truncate-lines t) ;; disables wrapping

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4) ;; C, C++
(setq inhibit-splash-screen t)
(setq visible-bell nil)
(setq blink-matching-paren t)
(setq case-fold-search nil)
;; (setq dired-listing-switches "-alh --group-directories-first")
;; (setq insert-directory-program "C:/Program Files/Git/usr/bin/ls.exe")
(setq dired-use-ls-dired t)
(setq dired-listing-switches "-alh --group-directories-first --ignore=.. --ignore=.")
(setq dired-free-space nil)
(setq dired-recursive-copies 'always)
;; (setq dired-recursive-deletes 'always)
(setq dired-dwim-target t)
(setq wdired-allow-to-change-permissions t)
(setq initial-scratch-message nil)
(setq read-buffer-completion-ignore-case t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq undo-limit 100000)
(setq undo-strong-limit 200000)
(setq load-path (cons "w:/Emacs/projects" load-path))
(setq grep-command "rg --line-number --ignore-case --regexp=\"\" --glob=\"*.{}\" .")

(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(add-hook 'c-mode-hook (lambda () (c-set-style "stroustrup"))) ;; C, C++
(add-hook 'c++-mode-hook (lambda () (c-set-style "stroustrup"))) ;; C, C++

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(eval-after-load 'grep '(setq grep-use-null-device nil))

(defvar __my-keymap (make-sparse-keymap))
(define-minor-mode __my-mode "My modal mode" :keymap __my-keymap)

;; this is the default project
(defvar build-script-path "w:/Projects/vgengine/code/")
(defvar build-script-name "./build.bat")
(defvar project-name "vgengine")
(defvar file-extensions "cpp,h")
(cd (concat "w:/Projects/" project-name))

;; @COMMANDS

(defun __update-cursor ()
  (setq cursor-type (if __my-mode 'box 'bar)))

(add-hook 'post-command-hook #'__update-cursor)

(defun __toggle-insert ()
  (interactive)
  (unless (not __my-mode)
    (setq __my-mode nil)
    (setq cursor-type 'bar)))

(defun __toggle-command ()
  (interactive)
  (unless __my-mode
    (setq __my-mode t)
    (setq cursor-type 'box)))

(add-hook 'find-file-hook #'__toggle-command)
(add-hook 'dired-mode-hook #'__toggle-command)

(defun __delete-word (arg)
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun __backward-delete-word (arg)
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun :clean-system-buffers ()
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (or (string-match-p "\\*.*\\*" (buffer-name buf))
                (eq major-mode 'dired-mode))
        (kill-buffer buf)))))

(defun :save-all ()
  (interactive)
  (save-some-buffers t))

(run-with-timer 0 30 ':save-all)

(defun :switch-to-buffer-no-default ()
  (interactive)
  (switch-to-buffer (read-buffer "Switch to buffer: " nil t)))

(defun :config ()
  (interactive)
  (find-file "w:/Emacs/init.el"))

;; you will actually do compilation mode, and you will use build.sh for
;; everything essentialy, and you will place it manually, and you will
;; manually go to w:/Emacs/projects/ and change the build script path
;; after manually placing it

(defun __init-project-name (arg1)
  (interactive "sChoose project name: ")
  (setq project-name arg1))

(defun __init-file-extensions (arg1)
  (interactive "sFile extensions (ex. cpp,h): ")
  (setq file-extensions arg1))

(defun :project-new ()
  (interactive)
  (call-interactively '__init-project-name)
  (call-interactively '__init-file-extensions)
  (find-file (concat "w:/Emacs/projects/" project-name ".el"))
  (insert (concat "(setq project-name \"" project-name "\")"))
  (electric-newline-and-maybe-indent)
  (insert "(setq build-script-path \"none\")")
  (electric-newline-and-maybe-indent)
  (insert "(setq build-script-name \"./none.none\")")
  (electric-newline-and-maybe-indent)
  (insert (concat "(setq file-extensions \"" file-extensions "\")"))
  (save-buffer)
  (cd (concat "w:/Projects/" project-name))
  (previous-buffer))

(defun :project-switch (arg1)
  (interactive "sChange to project: ")
  (load (concat arg1 ".el"))
  (cd (concat "w:/Projects/" project-name)))

(defun :note-create ()
  (interactive)
  (find-file (format-time-string "w:/notes/%Y%m%d%H%M%S--TBD--fleeting.txt")))

(defun :note-rename (arg1)
  (interactive "sNew note name: ")
  (save-buffer)
  (let ((name (file-name-nondirectory buffer-file-name)))
    (when (string-match "\\`\\([0-9]\\{14\\}--\\)\\(.*\\)\\'" name)
      (rename-file buffer-file-name
                   (setq buffer-file-name
                         (expand-file-name (concat (match-string 1 name) arg1 ".txt")
                                           default-directory))
                   t)
      (set-visited-file-name buffer-file-name t t)
      (rename-buffer (file-name-nondirectory buffer-file-name)))))

(defun :compile ()
  (interactive)
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd build-script-path)
  (compile build-script-name)
  (cd (file-name-directory buffer-file-name)))

(defun :ripgrep (arg1)
  (interactive "sripgrep: ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd (concat "w:/Projects/" project-name "/"))
  (grep (format "rg --line-number --ignore-case --regexp=\"%s\" --glob=\"*.{%s}\" ." arg1 file-extensions))
  (cd (file-name-directory buffer-file-name)))

(defun :ripgrep-current-buffer-only (arg1)
  (interactive "sripgrep buffer: ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (grep (format "rg --with-filename --line-number --ignore-case --regexp=\"%s\" -- %s" arg1 (buffer-file-name))))

(defun :ripgrep-dired-directory (arg1 arg2)
  (interactive "sripgrep string: \nsfiles (e.g. *.{cpp,h} or foo1.cpp foo2.cpp): ")
  (let* ((file-list (split-string arg2 " " t "[ \t\n\r]+"))
         (glob-args (mapconcat (lambda (f) (format "--glob=\"%s\"" f)) file-list " ")))
    (grep (format "rg --line-number --ignore-case --regexp=\"%s\" %s ." arg1 glob-args))))

(define-derived-mode grep-edit-mode text-mode "GrepEdit"
  "Major mode to edit grep output lines and save them back to files."
  (setq-local buffer-read-only nil)
  (let ((inhibit-read-only t))
    (remove-overlays)
    (remove-text-properties (point-min) (point-max) '(read-only t))))

(defun :grepedit-finish ()
  (interactive)
  (let ((count 0))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^\\([^:\n]+\\):\\([0-9]+\\):" nil t)
        (let* ((file (match-string 1))
               (line-num-str (match-string 2))
               (line-num (and line-num-str (string-to-number line-num-str)))
               (new-line (buffer-substring-no-properties
                          (point) (line-end-position))))
          (when (and file line-num (> line-num 0) (file-exists-p file))
            (let ((buf (find-buffer-visiting file)))
              (if buf
                  (with-current-buffer buf
                    (save-excursion
                      (goto-char (point-min))
                      (forward-line (1- line-num))
                      (let ((orig-line (buffer-substring-no-properties
                                        (line-beginning-position)
                                        (line-end-position))))
                        (unless (string-equal new-line orig-line)
                          (let ((inhibit-read-only t))
                            (delete-region (line-beginning-position) (line-end-position))
                            (insert new-line)
                            (basic-save-buffer)
                            (set-buffer-modified-p nil)
                            (set-visited-file-modtime)
                            (setq count (1+ count)))))))
                (with-temp-buffer
                  (let ((inhibit-message t)
                        (require-final-newline nil)
                        (backup-inhibited t)
                        (buffer-file-name file))
                    (insert-file-contents file nil nil nil t)
                    (goto-char (point-min))
                    (forward-line (1- line-num))
                    (let ((orig-line (buffer-substring-no-properties
                                      (line-beginning-position)
                                      (line-end-position))))
                      (unless (string-equal new-line orig-line)
                        (delete-region (line-beginning-position) (line-end-position))
                        (insert new-line)
                        (write-region (point-min) (point-max) file nil 'silent)
                        (set-visited-file-modtime)
                        (setq count (1+ count))))))))))))
    (message "Saved %d modified line(s)." count)))

(defun :grepedit-start ()
  (interactive)
  (grep-edit-mode)
  (setq buffer-read-only nil)
  (let ((inhibit-read-only t))
    (remove-overlays)
    (remove-text-properties (point-min) (point-max) '(read-only t)))
  (message "Grep buffer unlocked for editing."))

;; @KEYBINDINGS

(define-key isearch-mode-map (kbd "C-g") (lambda ()(interactive)(isearch-cancel)))

;; this is caps lock, use Windows Power Tools to remap to f19
(global-set-key (kbd "<f19>") #'__toggle-command)
(global-set-key (kbd "<tab>") 'dabbrev-expand)

(define-key __my-keymap (kbd "SPC") #'__toggle-insert)
(define-key __my-keymap (kbd "i") 'previous-line)
(define-key __my-keymap (kbd "k") 'next-line)
(define-key __my-keymap (kbd "j") 'backward-char)
(define-key __my-keymap (kbd "l") 'forward-char)
(define-key __my-keymap (kbd "J") 'left-word)
(define-key __my-keymap (kbd "L") 'right-word)
(define-key __my-keymap (kbd "3") #'(lambda () (interactive) (move-to-window-line 0) (previous-line))) ;; half page up
(define-key __my-keymap (kbd "4") #'(lambda () (interactive) (move-to-window-line -1) (next-line)))    ;; half page down
(define-key __my-keymap (kbd "a") 'move-beginning-of-line)
(define-key __my-keymap (kbd "e") 'move-end-of-line)
(define-key __my-keymap (kbd "A") 'move-beginning-of-line)
(define-key __my-keymap (kbd "E") 'move-end-of-line)
(define-key __my-keymap (kbd "d") 'delete-char)
(define-key __my-keymap (kbd "f") 'backward-delete-char)
(define-key __my-keymap (kbd "D") #'__delete-word)
(define-key __my-keymap (kbd "F") #'__backward-delete-word)
(define-key __my-keymap (kbd "s") 'newline)
(define-key __my-keymap (kbd "S") 'newline)
(define-key __my-keymap (kbd "v") 'set-mark-command)
(define-key __my-keymap (kbd "V") 'set-mark-command)
(define-key __my-keymap (kbd ",") 'rectangle-mark-mode)
(define-key __my-keymap (kbd "<") 'rectangle-mark-mode)
(define-key __my-keymap (kbd "w") 'yank)
(define-key __my-keymap (kbd "W") 'yank)
(define-key __my-keymap (kbd "t") 'undo)
(define-key __my-keymap (kbd "T") 'undo)
(define-key __my-keymap (kbd "c") 'kill-ring-save)
(define-key __my-keymap (kbd "C") 'kill-ring-save)
(define-key __my-keymap (kbd "z") 'kill-region)
(define-key __my-keymap (kbd "Z") 'kill-region)
(define-key __my-keymap (kbd "r") 'kill-line)
(define-key __my-keymap (kbd "R") 'kill-line)
(define-key __my-keymap (kbd "g") 'recenter)
(define-key __my-keymap (kbd "G") 'recenter)
(define-key __my-keymap (kbd "b") (kbd "C-u C-SPC")) ;; pop mark
(define-key __my-keymap (kbd "B") (kbd "C-u C-SPC")) ;; pop mark
;; (define-key __my-keymap (kbd "B") 'pop-global-mark)
(define-key __my-keymap (kbd "<tab>") 'indent-for-tab-command)
(define-key __my-keymap (kbd "q") 'other-window)
(define-key __my-keymap (kbd "Q") 'other-window)
(define-key __my-keymap (kbd "/") 'execute-extended-command)
(define-key __my-keymap (kbd "n") 'isearch-forward)
(define-key __my-keymap (kbd "N") 'isearch-forward)
(define-key __my-keymap (kbd "p") 'isearch-backward)
(define-key __my-keymap (kbd "P") 'isearch-backward)
(define-key __my-keymap (kbd "m") 'replace-string)
(define-key __my-keymap (kbd "M") 'replace-string)
(define-key __my-keymap (kbd ".") 'string-insert-rectangle)
(define-key __my-keymap (kbd ">") 'string-insert-rectangle)
(define-key __my-keymap (kbd "h") ':switch-to-buffer-no-default)
(define-key __my-keymap (kbd "H") #'(lambda () (interactive) (switch-to-buffer (other-buffer))))
(define-key __my-keymap (kbd "y") 'find-file)
(define-key __my-keymap (kbd "Y") 'project-find-file)
(define-key __my-keymap (kbd "'") 'comment-line)
(define-key __my-keymap (kbd "`") ':clean-system-buffers)
(define-key __my-keymap (kbd "1") 'beginning-of-defun)
(define-key __my-keymap (kbd "2") 'end-of-defun)
(define-key __my-keymap (kbd "5") 'backward-list)
(define-key __my-keymap (kbd "6") 'forward-list)
(define-key __my-keymap (kbd "7") 'next-error)
(define-key __my-keymap (kbd "8") 'previous-error)
(define-key __my-keymap (kbd "9") 'goto-line)
(define-key __my-keymap (kbd "-") 'xref-find-definitions)
(define-key __my-keymap (kbd "=") 'quick-calc)
;; (define-key __my-keymap (kbd ";") (kbd "C-g")) what is the name of command?

;; :ripgrep-dired-directory

(define-key __my-keymap (kbd "x c") ':compile)

(define-key __my-keymap (kbd "x h d f") 'describe-function)
(define-key __my-keymap (kbd "x h d v") 'describe-variable)
(define-key __my-keymap (kbd "x h d k") 'describe-key)
(define-key __my-keymap (kbd "x h s") 'where-is)
(define-key __my-keymap (kbd "x h e") 'eval-last-sexp)
(define-key __my-keymap (kbd "x h r") 'eval-region)
(define-key __my-keymap (kbd "x h b") 'eval-buffer)

(define-key __my-keymap (kbd "x m c") ':config)
(define-key __my-keymap (kbd "x m s") 'scratch-buffer)
(define-key __my-keymap (kbd "x m a") ':save-all)
(define-key __my-keymap (kbd "x m d") 'dired)
(define-key __my-keymap (kbd "x m b") 'kill-buffer)

(define-key __my-keymap (kbd "x e q") 'query-replace)
(define-key __my-keymap (kbd "x e i") 'beginning-of-buffer)
(define-key __my-keymap (kbd "x e k") 'end-of-buffer)
(define-key __my-keymap (kbd "x e h") 'delete-horizontal-space)
;; (define-key __my-keymap (kbd "x e j") 'backward-list)
;; (define-key __my-keymap (kbd "x e l") 'forward-list)
(define-key __my-keymap (kbd "x e p") 'insert-parentheses)
(define-key __my-keymap (kbd "x e u") 'delete-pair)

(define-key __my-keymap (kbd "x w d") 'split-window-below)
(define-key __my-keymap (kbd "x w c") 'delete-other-windows)
(define-key __my-keymap (kbd "x w q") 'delete-window)
(define-key __my-keymap (kbd "x w r") #'(lambda () (interactive) (delete-other-windows)(split-window-right)))

(define-key __my-keymap (kbd "x g g") ':ripgrep)
(define-key __my-keymap (kbd "x g b") ':ripgrep-current-buffer-only)

(define-key __my-keymap (kbd "x r s") #':grepedit-start)
(define-key __my-keymap (kbd "x r f") #':grepedit-finish)

(define-key __my-keymap (kbd "x p n") ':project-new)
(define-key __my-keymap (kbd "x p s") ':project-switch)

;; (define-key __my-keymap (kbd "x n s") ':note-tagsearch)
(define-key __my-keymap (kbd "x n n") ':note-create)
(define-key __my-keymap (kbd "x n r") ':note-rename)

;; f3 - start macro
;; f4 - end macro, replay last macro

(define-key minibuffer-local-completion-map (kbd "<tab>") #'minibuffer-complete)
(define-key minibuffer-local-filename-completion-map (kbd "<tab>") #'minibuffer-complete)


(define-key __my-keymap (kbd "u") #'ignore)
(define-key __my-keymap (kbd "o") #'ignore)
(define-key __my-keymap (kbd ";") #'ignore)
(define-key __my-keymap (kbd "K") #'ignore)
(define-key __my-keymap (kbd "I") #'ignore)


;; @TODO

;; polish keybindings
;; migrate all .org notes into .txt


;; go to line
;; cycle paste?
;; I and K should just go up by 1 ?
;; actually you can quit isearch with tab, so you should bind quit-keyboard actually...., and relayout some keys???,,,
;; upcase region (lowercase?)
;; count-words-region

;; make grep be case sensitive .......
;; make project-find-file not create a file ever
;; diff



;; (desktop-save-mode 1) (recentf-mode 1)
;; (save-place-mode 1)

;; (setq abbrev-ignore-case nil)
;; (setq abbrev-case-fold nil)
;; (setq abbrev-all-caps nil)

;; (global-auto-revert-non-file-buffers 1)


;; find-file autocompletion should add / automatically when it autocompletes to a folder..?

;; highlight regexp search in dired??
;; add icons??

;; marking multiple things in dired and then calling grep on them...
;; multi-occur and similar through buffer-menu so you can essentialy mark what to grep...

;; permissions in dired

;; move to trash instead of deleting in dired?

;; actual show some extra information in dired??

;; @INFO

;; ? on command in minibuffer to show possible completions
;; SPC for switch-to-buffer autocompletes
;; you can change font size with mouse wheel
;; can press Q on a lot of emacs' buffers to close them instantly
;; if you call grep in dired buffer, it will treat that directory as the base
;; use only dired-do-rename to rename files because it's buffer aware

;; enter directory, or open file in current buffer: RET, f
;; open directory or file in other window: o
;; go to parent directory: ^
;; mark, mark to delete, unmark, toggle marked: m, d, u, t (also can do this on a region)
;; execute deletion on marked to delete: x
;; create directory: +
;; dont show marked: k
;; reshow everything: g
;; mark files by regexp: % m
;; move marked files, rename current file: R
;; copy marked files, copy current file: C
;; delete marked files: D
;; mass rename with C-x C-q then C-c C-c

;; open, open in other window, go to parent, mark, unmark, toggle, unshow, reshow, mark by regexp, move copy delete marked,
;; rename, mass rename, create directory

;; find-name-dired will find all files matching pattern recursively in a directory

;; dired-do-search will search for a regexp hit in marked files, to go to next hit call fileloop-continue
;; dired-do-query-replace-regexp essentialy does the same but replace instead

;; new file in dired? -> just make one through find-file (then revert-buffer in dired to make it show...)
