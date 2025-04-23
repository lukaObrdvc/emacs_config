;; Emacs 29.3_2


;; @CONFIGS

(setq load-path (cons "w:/Emacs/projects" load-path))
;; this is the default project
(defvar build-script-directory "w:/Projects/vgengine/code")
(defvar build-script-name "build")
(defvar project-name "vgengine")
(defvar code-file-extensions "cpp,h")
(cd (concat "w:/Projects/" project-name))


;; (add-to-list 'load-path "w:/Emacs/packages")

(add-to-list 'custom-theme-load-path "w:Emacs/themes")
;; (load-theme 'moonrocks t)
;; (load-theme 'desert-sapphire t)
;; (load-theme 'simplecoder t)
;; (load-theme 'gruber-darker t)
(load-theme 'naysayer t)

;; (set-face-attribute 'default nil :font "JetBrains Mono Regular-11")
;; (set-face-attribute 'default nil :font "Inconsolata-g-11")
;; (set-face-attribute 'default nil :font "Liberation Mono-11")
;; (set-face-attribute 'default nil :font "Hack-11")
;; (set-face-attribute 'default nil :font "Iosevka-12")
;; (set-face-attribute 'default nil :font "Cascadia Mono-11")
;; (set-face-attribute 'default nil :font "JuliaMono ExtraBold-10")
;; (set-face-attribute 'default nil :font "DejaVu Sans Mono-12")
;; (set-face-attribute 'default nil :font "Courier New-13")
;; (set-face-attribute 'default nil :font "Consolas-12.5")
(set-face-attribute 'default nil :font "Consolas-13")
;; (set-face-attribute 'default nil :font "Consolas-16")

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
(setq blink-matching-paren t)
;; (recentf-mode 1)
;; (save-place-mode 1)
(global-auto-revert-mode 1)
;; (global-auto-revert-non-file-buffers 1)

(setq case-fold-search nil)
;; (setq isearch-allow-scroll t)
;; (setq isearch-lazy-count t)
(define-key isearch-mode-map (kbd "C-g") (lambda ()(interactive)(isearch-cancel)))

;; ------ ido, fido, abbrev
(abbrev-mode 1)
;; (setq abbrev-ignore-case nil)
;; (setq abbrev-case-fold nil)
;; (setq abbrev-all-caps nil)
(require 'ido)
(setq ido-everywhere t)
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-case-fold t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
;; (fido-mode t)
(setq ido-auto-merge-work-directories-length -1)
;; ------

;; (desktop-save-mode 1)

(add-hook 'dired-mode-hook 'dired-hide-details-mode)

(setq initial-scratch-message nil)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq undo-limit 100000)
(setq undo-strong-limit 200000)

(eval-after-load 'grep '(setq grep-use-null-device nil))

(defvar __MyKeymap (make-sparse-keymap))
(define-minor-mode __MyMode
  "My modal mode"
  :keymap __MyKeymap)


;; @@ORG

(require 'org)
(setq org-M-RET-may-split-line nil)
(setq org-hide-emphasis-markers t)
(setq org-hide-leading-stars t)
(add-hook 'org-mode-hook 'org-indent-mode)
(setq org-hide-block-startup t)
(setq insert-heading-respect-content t) ;; this appears to not work...
(setq org-log-done nil)
(setq org-log-into-drawer nil)
;; (setq org-agenda-files (directory-files-recursively "w:Notes/" "\\.org$"))
;; figure out if this works...
(setq org-todo-keywords '((sequence "TODO(t)" "|" "CANCEL(c!)" "DONE(d!)")))
(setq org-image-actual-width nil)
(setq imagemagick-enabled-types t)
(setq org-agenda-window-setup 'other-window)

;; @COMMANDS

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
(add-hook 'find-file-hook #'__ToggleCommand)

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

(defun :clean-system-buffers ()
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (or (string-match-p "\\*.*\\*" (buffer-name buf))
                (eq major-mode 'dired-mode))
        (kill-buffer buf)))))

;; Inhibit message when there is something to save ??
(defun :save-all ()   ;; change to :save ??
  (interactive)
  (save-some-buffers t)
  )
(run-with-timer 0 30 ':save-all)

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
  (interactive "sLanguage file extensions (ex. \"cpp,h\"): ")
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
  ;; (if (string= arg1 "quick") (find-file "quick.c")) :quick-open does this?
  )

;; git init repo ?
;; git pull ?
(defun :git-push (arg1)
  (interactive "sCommit message: ")
  (:save-all)
  (shell-command "git add .")
  (shell-command (format "git commit -m \"%s\"" arg1))
  (shell-command "git push origin main")
  )

(defun :quick-open ()
  (interactive)
  (load "quick.el")
  (find-file "w:/Projects/quick/quick.c")
  )

;; if no scratch buffer then don't kill one..
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
  (:save-all)
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

(defun :tags-make ()
  (interactive)
  (:save-all)
  (cd (concat "w:/Projects/" project-name "/"))
  (shell-command "ctags -e -R")
  (cd (file-name-directory buffer-file-name))
  )

(defun __grep (arg1)
  (interactive "sgrep findstr: ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd (concat "w:/Projects/" project-name "/"))
  (grep (format "findstr -s -n -i -r \"%s\" %s" arg1 code-file-extensions))
  (cd (file-name-directory buffer-file-name))
  )

(defun :ripgrep (arg1)
  (interactive "sripgrep: ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd (concat "w:/Projects/" project-name "/"))
  (grep (format "rg --line-number --ignore-case --regexp=\"%s\" --glob=\"*.{%s}\" ." arg1 code-file-extensions))
  (cd (file-name-directory buffer-file-name))
  )

(defun :ripgrep-c-functions ()
  (interactive)
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd (concat "w:/Projects/" project-name "/"))
  (grep "rg --line-number --ignore-case --regexp=\"^[[:space:]]*(inline|static|extern)?[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\\([^)]*\\)[[:space:]]*\\{?$\" --glob=\"*.c\" --glob=\"*.h\" .")
  (cd (file-name-directory buffer-file-name))
  )

(defun __grep-current-buffer-only (arg1)
  (interactive "sgrep findstr: ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (grep (format "findstr -s -n -i -r \"%s\" %s" arg1 (buffer-file-name)))
  )

(defun :ripgrep-current-buffer-only (arg1)
  (interactive "sripgrep buffer: ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (grep (format "rg --with-filename --line-number --ignore-case --regexp=\"%s\" -- %s" arg1 (buffer-file-name)))
  )

(defun :compile ()
  (interactive)
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd build-script-directory)
  (compile build-script-name)
  (cd (file-name-directory buffer-file-name))
  )

(defun :note-create-in-arena ()
  (interactive)
  (find-file (concat "w:/Notes/a/" (format-time-string "%Y%m%d%H%M%S") "_TBD" ".org"))
  (insert "#+TITLE: " "TBD" "\n")
  (insert "$:" "fleeting" "\n")
  (insert "Created on: " (format-time-string "%Y%m%d%H%M%S") "\n\n")
  (insert "* Overview" "\n")
  (:save-all)
  )

;; here I am not adding a datetime in front of the filename in
;; order to make it unique, because we don't want to name these
;; like that, so just make sure you don't have a conflicting filename
;; when you create a new note... I quess find-file will just open the
;; lates TBD in that case, which is good I thinks...
(defun :note-create-in-general ()
  (interactive)
  (find-file (concat "w:/Notes/" "TBD" ".org"))
  (insert "#+TITLE: " "TBD" "\n")
  (insert "$:" "fleeting" "\n")
  (insert "Created on: " (format-time-string "%Y%m%d%H%M%S") "\n\n")
  (insert "* Overview" "\n")
  (:save-all)
  )

;; this doesn't work for general notes, because they don't have
;; the datetime identifier in front anymore, maybe reverse..??
(defun :note-rename (arg1)
  (interactive "sNew note title: ")
  (:save-all)
  (let* ((Dir (file-name-directory buffer-file-name))
         (NewName (concat (substring (file-name-base buffer-file-name) 0 14) "_" arg1 ".org"))
         (NewPath (concat Dir NewName))
         )
    (rename-file buffer-file-name NewPath)
    (kill-buffer)
    (find-file NewPath)
    (save-excursion
      (goto-char (point-min))
      (delete-region (line-beginning-position) (line-end-position))
      (insert "#+TITLE: " arg1)
      )
    (save-buffer)
    )
  )

(defun :note-tagfile ()
  (interactive)
  (find-file "w:/Notes/tags.org")
  )

(defun :note-ripgrep (arg1)
  (interactive "sripgrep notes: ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd "w:/Notes/")
  (grep (format "rg --line-number --ignore-case --regexp=\"%s\" --glob=\"*.org\" ." arg1))
  (cd (file-name-directory buffer-file-name))
  )

(defun :note-tagsearch (query)
  (interactive "sSearch notes by tags (+AND, |OR, ~NOT): ")
  (:save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd "w:/Notes/")
  
  (let* ((not-tags (if (string-match "~\\([^+|~]+\\)" query)
                       (match-string 1 query) ""))
         (or-tags  (if (string-match "|\\([^+|~]+\\)" query)
                       (match-string 1 query) ""))
         (and-tags (if (string-match "+\\([^+|~]+\\)" query)
                       (match-string 1 query) ""))
         
         (not-part (if (string-empty-p not-tags) ""
                     (format "(?!.*\\b(?:%s)\\b)" 
                             (replace-regexp-in-string "," "|" not-tags))))
         (or-part (if (string-empty-p or-tags) ""
                    (format "(?=.*\\b(?:%s)\\b)" 
                            (replace-regexp-in-string "," "|" or-tags))))
         (and-part (if (string-empty-p and-tags) ""
                     (mapconcat (lambda (tag) (format "(?=.*\\b%s\\b)" tag))
                                (split-string and-tags ",") "")))

         (rg-command (format "rg --pcre2 \"\\$:%s%s%s\" --line-number --ignore-case --glob=\"*.org\" ."
                             not-part or-part and-part)))
    (grep rg-command)
    )
  (cd (file-name-directory buffer-file-name))
  )


(define-derived-mode grep-edit-mode text-mode "GrepEdit"
  (setq-local buffer-read-only nil)
  (let ((inhibit-read-only t))
    (remove-overlays)
    (remove-text-properties (point-min) (point-max) '(read-only t)))
  )

(defun __evil-wgrep-unfuck-buffer ()
  (interactive)
  (grep-edit-mode)
  (setq buffer-read-only nil)
  (let ((inhibit-read-only t))
    (remove-overlays)
    (remove-text-properties (point-min) (point-max) '(read-only t)))
  (message "Buffer fully unlocked. Edit freely, then M-x __evil-wgrep-save.")
  )

(defun __evil-wgrep-save-if-diff ()
  (interactive)
  (let ((count 0))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^\\([^:\n]+\\):\\([0-9]+\\):" nil t)
        (let* ((file (match-string 1))
               (line-num (string-to-number (match-string 2)))
               (new-line (buffer-substring-no-properties (point) (line-end-position))))
          (when (file-exists-p file)
            (with-temp-buffer
              (insert-file-contents file)
              (goto-char (point-min))
              (forward-line (1- line-num))
              (let ((original-line (buffer-substring-no-properties
                                    (line-beginning-position)
                                    (line-end-position))))
                (unless (string-equal new-line original-line)
                  (delete-region (line-beginning-position) (line-end-position))
                  (insert new-line)
                  (write-region (point-min) (point-max) file nil 'silent)
                  (setq count (1+ count)))))))))
    (message "Saved %d modified line(s)." count))
  )

;; @KEYBINDINGS

;; this is caps lock, use Windows Power Tools to remap to f19
(global-set-key (kbd "<f19>") #'__ToggleCommand)
(global-set-key (kbd "<tab>") 'dabbrev-expand)

(define-key __MyKeymap (kbd "SPC") #'__ToggleInsert)
(define-key __MyKeymap (kbd "i") 'previous-line)
(define-key __MyKeymap (kbd "k") 'next-line)
(define-key __MyKeymap (kbd "j") 'backward-char)
(define-key __MyKeymap (kbd "l") 'forward-char)
(define-key __MyKeymap (kbd "J") 'left-word)
(define-key __MyKeymap (kbd "L") 'right-word)
(define-key __MyKeymap (kbd "3") #'(lambda () (interactive) (move-to-window-line 0) (previous-line)))
(define-key __MyKeymap (kbd "4") #'(lambda () (interactive) (move-to-window-line -1) (next-line)))
(define-key __MyKeymap (kbd "a") 'move-beginning-of-line)
(define-key __MyKeymap (kbd "e") 'move-end-of-line)
(define-key __MyKeymap (kbd "A") 'move-beginning-of-line)
(define-key __MyKeymap (kbd "E") 'move-end-of-line)
(define-key __MyKeymap (kbd "d") 'delete-char)
(define-key __MyKeymap (kbd "f") 'backward-delete-char)
(define-key __MyKeymap (kbd "D") #'__delete-word)
(define-key __MyKeymap (kbd "F") #'__backward-delete-word)
(define-key __MyKeymap (kbd "s") 'newline)
(define-key __MyKeymap (kbd "S") 'newline)
(define-key __MyKeymap (kbd "v") 'set-mark-command)
(define-key __MyKeymap (kbd "V") 'set-mark-command)
(define-key __MyKeymap (kbd ",") 'rectangle-mark-mode)
(define-key __MyKeymap (kbd "<") 'rectangle-mark-mode)
(define-key __MyKeymap (kbd "w") 'yank)
(define-key __MyKeymap (kbd "W") 'yank)
(define-key __MyKeymap (kbd "t") 'undo)
(define-key __MyKeymap (kbd "T") 'undo)
(define-key __MyKeymap (kbd "c") 'kill-ring-save)
(define-key __MyKeymap (kbd "C") 'kill-ring-save)
(define-key __MyKeymap (kbd "z") 'kill-region)
(define-key __MyKeymap (kbd "Z") 'kill-region)
(define-key __MyKeymap (kbd "r") 'kill-line)
(define-key __MyKeymap (kbd "R") 'kill-line)
;; (define-key __MyKeymap (kbd "R") '__duplicate-line)
(define-key __MyKeymap (kbd "g") 'recenter)
(define-key __MyKeymap (kbd "G") 'recenter)
(define-key __MyKeymap (kbd "b") (kbd "C-u C-SPC")) ;; pop mark
(define-key __MyKeymap (kbd "B") (kbd "C-u C-SPC")) ;; pop mark
;; (define-key __MyKeymap (kbd "B") 'pop-global-mark)
(define-key __MyKeymap (kbd "<tab>") 'indent-for-tab-command)
(define-key __MyKeymap (kbd "q") 'other-window)
(define-key __MyKeymap (kbd "Q") 'other-window)
(define-key __MyKeymap (kbd "/") 'execute-extended-command)
(define-key __MyKeymap (kbd "n") 'isearch-forward)
(define-key __MyKeymap (kbd "N") 'isearch-forward)
(define-key __MyKeymap (kbd "p") 'isearch-backward)
(define-key __MyKeymap (kbd "P") 'isearch-backward)
(define-key __MyKeymap (kbd "m") 'replace-string)
(define-key __MyKeymap (kbd "M") 'replace-string)
(define-key __MyKeymap (kbd ".") 'string-insert-rectangle)
(define-key __MyKeymap (kbd ">") 'string-insert-rectangle)
(define-key __MyKeymap (kbd "h") 'switch-to-buffer)
(define-key __MyKeymap (kbd "H") #'(lambda () (interactive) (switch-to-buffer (other-buffer))))
(define-key __MyKeymap (kbd "y") 'find-file)
(define-key __MyKeymap (kbd "Y") 'find-file)
;; (define-key __MyKeymap (kbd "Y") 'project-find-file) make this a command probably instead
;; (define-key __MyKeymap (kbd "o") 'imenu)
(define-key __MyKeymap (kbd "'") 'comment-line)
(define-key __MyKeymap (kbd "\\") 'next-error)
(define-key __MyKeymap (kbd "]") 'previous-error)
(define-key __MyKeymap (kbd "`") ':clean-system-buffers)
(define-key __MyKeymap (kbd "=") 'quick-calc)
(define-key __MyKeymap (kbd "1") 'beginning-of-defun)
(define-key __MyKeymap (kbd "2") 'end-of-defun)
(define-key __MyKeymap (kbd "7") 'backward-list)
(define-key __MyKeymap (kbd "8") 'forward-list)
(define-key __MyKeymap (kbd "5") 'xref-find-definitions)
;; (define-key __MyKeymap (kbd ";") (kbd "C-g")) what is the name of command?

(define-key __MyKeymap (kbd "x c") ':compile)

(define-key __MyKeymap (kbd "x h d f") 'describe-function)
(define-key __MyKeymap (kbd "x h d v") 'describe-variable)
(define-key __MyKeymap (kbd "x h d k") 'describe-key)
(define-key __MyKeymap (kbd "x h s") 'where-is)
(define-key __MyKeymap (kbd "x h e") 'eval-last-sexp)
(define-key __MyKeymap (kbd "x h r") 'eval-region)
(define-key __MyKeymap (kbd "x h b") 'eval-buffer)

(define-key __MyKeymap (kbd "x m c") ':config)
(define-key __MyKeymap (kbd "x m t") ':tags-make)
(define-key __MyKeymap (kbd "x m s") 'scratch-buffer)
(define-key __MyKeymap (kbd "x m a") ':save-all)
(define-key __MyKeymap (kbd "x m o") 'occur)
(define-key __MyKeymap (kbd "x m d") 'dired)
(define-key __MyKeymap (kbd "x m b") 'kill-buffer)

(define-key __MyKeymap (kbd "x e q") 'query-replace)
(define-key __MyKeymap (kbd "x e i") 'beginning-of-buffer)
(define-key __MyKeymap (kbd "x e k") 'end-of-buffer)
(define-key __MyKeymap (kbd "x e h") 'delete-horizontal-space)
;; (define-key __MyKeymap (kbd "x e j") 'backward-list)
;; (define-key __MyKeymap (kbd "x e l") 'forward-list)
(define-key __MyKeymap (kbd "x e p") 'insert-parentheses)
(define-key __MyKeymap (kbd "x e u") 'delete-pair)
(define-key __MyKeymap (kbd "x e g") 'goto-line)

(define-key __MyKeymap (kbd "x w d") 'split-window-below)
(define-key __MyKeymap (kbd "x w c") 'delete-other-windows)
(define-key __MyKeymap (kbd "x w q") 'delete-window)
(define-key __MyKeymap (kbd "x w r") #'(lambda () (interactive) (delete-other-windows)(split-window-right)))

;; (define-key __MyKeymap (kbd "x g g") '__grep)
;; (define-key __MyKeymap (kbd "x g b") '__grep-current-buffer-only)
(define-key __MyKeymap (kbd "x g g") ':ripgrep)
(define-key __MyKeymap (kbd "x g b") ':ripgrep-current-buffer-only)

(define-key __MyKeymap (kbd "x r s") #'__evil-wgrep-unfuck-buffer)
(define-key __MyKeymap (kbd "x r f") #'__evil-wgrep-save-if-diff)

(define-key __MyKeymap (kbd "x f g p") ':git-push)

(define-key __MyKeymap (kbd "x q o") ':quick-open)
(define-key __MyKeymap (kbd "x q r") ':quick-run)
(define-key __MyKeymap (kbd "x q s") ':quick-save)
(define-key __MyKeymap (kbd "x q l") ':quick-load)

(define-key __MyKeymap (kbd "x p n") ':project-new)
(define-key __MyKeymap (kbd "x p s") ':project-switch)

(define-key __MyKeymap (kbd "x n a") ':note-create-in-general)
(define-key __MyKeymap (kbd "x n n") ':note-create-in-arena)
(define-key __MyKeymap (kbd "x n r") ':note-rename)
(define-key __MyKeymap (kbd "x n t") ':note-tagfile)
(define-key __MyKeymap (kbd "x n g") ':note-ripgrep)
(define-key __MyKeymap (kbd "x n s") ':note-tagsearch)

(define-key __MyKeymap (kbd "x o c") 'org-cycle)
(define-key __MyKeymap (kbd "x o g") 'org-cycle-global)
(define-key __MyKeymap (kbd "x o i") 'org-display-inline-images)
(define-key __MyKeymap (kbd "x o r") 'org-remove-inline-images)
(define-key __MyKeymap (kbd "x o l") 'org-latex-preview)
(define-key __MyKeymap (kbd "x o o") 'org-open-at-point)

;; f3 - start macro
;; f4 - end macro, replay last macro


(define-key __MyKeymap (kbd "u") #'ignore)
(define-key __MyKeymap (kbd "o") #'ignore)
(define-key __MyKeymap (kbd ";") #'ignore)
(define-key __MyKeymap (kbd "6") #'ignore)
(define-key __MyKeymap (kbd "K") #'ignore)
(define-key __MyKeymap (kbd "I") #'ignore)


;; @TODO

;; make wgrep be case sensitive blud.......

;; git stuff needed,  MAGIT, diff
;; project stuff needed
;; dired stuff and directory in general
;; desktop-save-mode??
;; theme stuffs
;; polish keybindings

;; run project...

;; delete-file
;; rename-file
;; make-directory
;; rename-directory
;; delete-directory
;; ido-list-directory or similar...



;; less important here:


;; rename certain commands to prefix with : , also Pascal case or something in this direction

;; adding keywords with font-lock can do so much highlighting......
;; how to bold text that begins with @ ??

;; you can make a function that remembers a column number and then
;; pastes whitespace until point reaches that column number for ease
;; of formating
;; formating for code stuff, and formating for text stuff when adding in text

;; upcase region (lowercase?)
;; maybe change to .txt default for notes, and also maybe use dired for notes
;; automatic guard?


;; grep editting stuff???


;; @INFO

;; in org moving by defuns moves by headers (other stuffs...??)

;; ? on command in minibuffer to show possible completions
;; SPC for find-file autocompletes
;; you can change font size with mouse wheel, and in the buffer border you can see offset from original
;; can press Q on a lot of emacs' buffers to close them instantly

;; if you press caps-lock while in minibuffer can you hit your Quit hotkey
;; and get it to work there??? (yes but not for isearch, because hitting
;; caps-lock gets out of it...)




