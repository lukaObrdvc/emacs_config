;; Emacs 29.3_2

;; BIGGIE DEAL: when adding env vars, add them to PATH variable, not just as a new variable............

;; @TODO

;; maybe jkl; for movement is not that bad (or vim)


;; have to bind/unbind stuff for every shift version of key....
;; same for alt, ctrl? (simialr?)
;; always be in __MyMode when opening file/buffer??
;; how to disable G recentering to top or bot??

;; how to make line wraps not from start, but kind of indented??
;; maybe add smooth scrolling??
;; make buffer name in modeline stand out...
;; adding keywords with font-lock can do so much highlighting......
;; how to bold text that begins with @ ??
;; should probably add hl line...

;; how can I make text (mainly in text based files) reformat entirely
;; when I want to add words inside a paragraph and maintain some horizontal
;; margin, I want to entire paragraph to reformat.....


;; beginning-of-visual-line is decent with wrapping lines...??

;; multiple cursors?
;; C-{ will auto scope and stuff?
;; auto reindent when yanking ??
;; guard (automatic?)
;; add horizontal whitespace up to point in a region
;; make an emacs function that aligns the all = with the horizontally furthest one


;; org           
;; org-habit     
;; org-journal   
;; org-noter     
;; org-pomodoro  
;; org-recur     
;; org-roam      
;; org-superstar 
;; org-tree-slide

;; ledger
;; look for other stuff in themes...?


;; @CONFIGS

(setq load-path (cons "w:/Emacs/projects" load-path))
;; this is the default project
(defvar build-script-directory "w:/Projects/vgengine/code")
(defvar build-script-name "build")
(defvar project-name "vgengine")
(defvar code-file-extensions "*.h *.c")
;; add cd to default project here
;; split right as well by default


(add-to-list 'load-path "w:/Emacs/packages")
(require 'wgrep)

(add-to-list 'custom-theme-load-path "w:Emacs/themes")
(load-theme 'moonrocks t)
;;(load-theme 'desert-sapphire t)

;; (set-face-attribute 'default nil :font "JetBrains Mono Regular-11")
;; (set-face-attribute 'default nil :font "Inconsolata-g-11")
;; (set-face-attribute 'default nil :font "Liberation Mono-11")
;; (set-face-attribute 'default nil :font "Hack-11")
;; (set-face-attribute 'default nil :font "Iosevka-12")
;; (set-face-attribute 'default nil :font "Cascadia Mono-11")
;; (set-face-attribute 'default nil :font "JuliaMono ExtraBold-10")

;; (set-face-attribute 'default nil :font "DejaVu Sans Mono-12")
(set-face-attribute 'default nil :font "Consolas-12.5")

(setq inhibit-splash-screen t)
(setq visible-bell nil)
(set-message-beep 'silent)
(set-default 'truncate-lines t) ;; disables wrapping
;; (setq visual-wrap-prefix-mode t)     ???
;; (setq global-visual-wrap-prefix-mode t)   ???


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
;; (recentf-mode 1)
;; (save-place-mode 1)
(global-auto-revert-mode 1) ;; for ** buffers as well exists one....

;; (setq isearch-allow-scroll t)
;; (setq isearch-lazy-count t)

(require 'ido)
(ido-mode t)
(ido-everywhere t)
(fido-mode t)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq undo-limit 100000)
(setq undo-strong-limit 200000)

(eval-after-load 'grep '(setq grep-use-null-device nil))

;; do same for Ido Completions ...?
(push '("\\*completions\\*"
        (display-buffer-use-some-window display-buffer-pop-up-window)
        (inhibit-same-window . t))
      display-buffer-alist)

(defvar __MyKeymap (make-sparse-keymap))
(define-minor-mode __MyMode
  "My modal mode"
  :keymap __MyKeymap)


;; @@ORG CONFIGS

(require 'org)
(setq org-M-RET-may-split-line nil)
(setq org-hide-emphasis-markers t)
(setq org-hide-leading-stars t)
(add-hook 'org-mode-hook 'org-indent-mode)
;; (setq org-pretty-entities t) ;; this is iffy, because _ will put in down
(setq org-hide-block-startup t)
(setq insert-heading-respect-content t)
(setq org-log-done nil)
(setq org-log-into-drawer nil)
;; have to add agenda files, directory...
(setq org-agenda-files (directory-files-recursively "w:Notes/" "\\.org$"))
(setq org-todo-keywords '((sequence "TODO(t)" "|" "CANCEL(c!)" "DONE(d!)")))
(setq org-image-actual-width nil)
(setq imagemagick-enabled-types t)
(setq org-agenda-window-setup 'other-window)

;; probably comment out these later...
(setq org-use-tag-inheritance t)
(setq org-capture-use-agenda-date nil)
(setq org-capture-templates-contexts nil)
(setq org-capture-window-setup 'other-window)

;; (defun my/org-agenda-add-title ()
;;   (when (and (string-match "\\.org$" (or buffer-file-name ""))
;;              (not (org-before-first-heading-p)))
;;     (let ((title (or (org-collect-keywords '("TITLE")) "Untitled")))
;;       (insert (format "* %s\n" (cadr (assoc "TITLE" title)))))))

;; (add-hook 'org-agenda-mode-hook #'my/org-agenda-add-title)

;; (setq org-capture-templates
;;       '(("n" "New Searchable Note" entry
;;          (file (lambda () (concat "w:/Notes/" (format-time-string "%Y%m%d-%H%M%S") "-note.org")))
;;          "* Overview\n  Created on: %U\n\n  %?"
;;          :empty-lines 1)))

;; auto adds to agenda files
(defun my/org-add-to-agenda ()
  (when (and buffer-file-name
             (string-match-p (expand-file-name "w:/Notes/") buffer-file-name))
    (unless (member buffer-file-name org-agenda-files)
      (setq org-agenda-files (append org-agenda-files (list buffer-file-name))))))

(add-hook 'after-save-hook 'my/org-add-to-agenda)


;; (defun my/org-auto-add-parent-tags ()
;;   "Ensure subtags inherit their parent tag."
;;   (when-let ((tags (org-get-tags)))
;;     (when (member "keto" tags)
;;       (org-set-tags (cons "diet" tags)))
;;     (when (member "paleo" tags)
;;       (org-set-tags (cons "diet" tags)))
;;     (when (member "cardio" tags)
;;       (org-set-tags (cons "exercise" tags)))
;;     (when (member "strength" tags)
;;       (org-set-tags (cons "exercise" tags)))))



;; how to show title in agenda view
;; how to link to a file now?
;; what about showing the inheritance hierarchy of tags?
;; how to insert metadata
;; how to open capture in other window

;; datetime as filename always, means can't easily distuinguish
;;   names of buffers (or files for that matter)
;; can you append all files choosen to one file?




;;; you basically want two types of notes, one type are in arena,
;;; they are more temporary, you just create them quickly and put them
;;; all there, and you make sure to tag them properly, the other ones
;;; are more structured and long term and are more monolithic, so
;;; you create them manually, and you can use the temporary notes
;;; to filter them by tags and extract information from them and
;;; put it into these more permanent notes

;;; since knowledge is hierarchical, you always want to approach it
;;; that way, if it happens that in the special case you see a
;;; connection between these permanent notes, just make a note
;;; about that connection, basically do linking between these [tag properly...]
;;; files (or abstract it into a different file that links toward
;;;  them), this way you can reason between connections, but also
;;; this way these permanent notes will, and should never link
;;; toward the more temporary notes; again what matters is what
;;; is in your head, and you shouldn't need to link together
;;; everything like a wiki, you should already know certain
;;; concepts or know where they are in files and be able to
;;; refresh your memory about them, this way you don't need
;;; a thing like org-roam...

;;; basically do your organization with tags, make them very simple
;;; and don't fuck up with their use so that it's hard to reorganize
;;; something, if you need more proper organization, hierarchy, then
;;; do it inside the file, with org outlining

;;; basically if you take a note about some deep thought
;;; about some subject, or connection, or insight, or deep undestanding
;;; or whatever, or similar stuff like that, where you just want to
;;; note it down and not worry about the structure initially as you
;;; continue to think about it more, and process it, then you just
;;; note it down, and tag it properly that's all it takes, proper usage
;;; of tags, [in fact the same way you used the canvas or notable or
;;;   notepad, you just either create a note {and then never find it again kind of...}, or you pick a canvas
;;;   and pick a place there and just note something down and that's it
;;;   it's not even well organized and doesn't look that good, but it's
;;;   in a proper place, where you can find it again and to what it's
;;;   associated with and you can then restructure all of that information
;;;   later], in order to associate a note with other things and find it
;;; later and restructure all of the information over time...
;;; or also do restructuring inside the file with org markup and stuffs...

;;; have a special file that deals with tags and their hierarchies...

;;; maybe figure out some directory stuff, andor filenames..
;;;  dailies like worklogging, ?templates, .. .  .

;;; but then you kind of just like figure out the tags !

;;; also you can actually view pdfs in DocView bruh...

;; look up hyprelinks guide org, cream guy lul...

;; what happens when you change tags???


;; (setq org-tag-alist '((:startgroup . nil)
                      ;; ("general" . ?g)
                        ;; ("work" . ?w)
                        ;; ("emacs" . ?e)
                      ;; (:endgroup . nil)))

;; (setq org-tag-alist '((:startgroup . nil)
;;                       ("diet" . ?d)   ;; Main category
;;                         ("keto" . ?k)  ;; Subcategory of diet
;;                         ("paleo" . ?p)
;;                       (:endgroup . nil)
;;                       ("exercise" . ?e)   ;; Another category
;;                         ("cardio" . ?c)
;;                         ("strength" . ?s)))


;; (setq org-list-automatic-rules '((newline . t)))
;; (setq org-list-automatic-rules '((newline . t) (space . t)))
;; (setq org-adapt-indentation nil)
;; (setq org-list-indent-offset 0)


;; I mean there's mainly this:
;; linking, tagging, searching, creating, modifying
;; and you need to make these convenient basically....







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

;; doesn't close org stuff..?
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

(defun __ripgrep (arg1)
  (interactive "sripgrep: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd (concat "w:/Projects/" project-name "/"))
  (grep (format "rg --line-number --ignore-case --regexp=\"%s\" --glob=\"*.{c,h}\" ." arg1));;code-file-extensions))
  (cd (file-name-directory buffer-file-name))
  )

(defun __grep-current-buffer-only (arg1)
  (interactive "sgrep findstr: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (grep (format "findstr -s -n -i -r \"%s\" %s" arg1 (buffer-file-name)))
  )

(defun __ripgrep-current-buffer-only (arg1)
  (interactive "sripgrep buffer: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (grep (format "rg --with-filename --line-number --ignore-case --regexp=\"%s\" -- %s" arg1 (buffer-file-name)))
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

(defun :note-create-in-arena ()
  (interactive)
  (find-file (concat "w:/Notes/a/" (format-time-string "%Y%m%d%H%M%S") "_TBD" ".org"))
  (insert "#+TITLE: " "TBD" "\n")
  (insert "$:" "fleeting" "\n")
  (insert "Created on: " (format-time-string "%Y%m%d%H%M%S") "\n\n")
  (insert "* Overview" "\n")
  (__save-all)
  )

(defun :note-create-in-general ()
  (interactive)
  (find-file (concat "w:/Notes/" (format-time-string "%Y%m%d%H%M%S") "_TBD" ".org"))
  (insert "#+TITLE: " "TBD" "\n")
  (insert "$:" "fleeting" "\n")
  (insert "Created on: " (format-time-string "%Y%m%d%H%M%S") "\n\n")
  (insert "* Overview" "\n")
  (__save-all)
  )

(defun :note-rename (arg1)
  (interactive "sNew note title: ")
  (let* ((Dir (file-name-directory buffer-file-name))
         (NewName (concat (substring (file-name-base buffer-file-name) 0 14) "_" arg1 ".org"))
         (NewPath (concat Dir NewName))
         )
    (rename-file buffer-file-name NewPath)
    (kill-buffer)
    (find-file NewPath)
    (save-excursion
      (goto-char (point-min))
      (kill-line)
      (insert "#+TITLE: " arg1)
      )
    (save-buffer)
    )
  )

(defun :note-tagfile ()
  (interactive)
  (find-file "w:/Notes/TAGS.org")
  )

(defun :note-ripgrep (arg1)
  (interactive "sripgrep notes: ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd "w:/Notes/")
  (grep (format "rg --line-number --ignore-case --regexp=\"%s\" --glob=\"*.org\" ." arg1))
  (cd (file-name-directory buffer-file-name))
  )

(defun :note-tagsearch (query)
  (interactive "sSearch notes by tags (+AND, |OR, ~NOT): ")
  (__save-all)
  (if (= (count-windows) 1) (split-window-right))
  (cd "w:/Notes/")
  
  ;; (grep (format "rg --pcre2 \"#\\+FILETAGS:(?!.*\\b(?:%s)\\b)(?=.*\\b(?:%s)\\b)%s\" --line-number --ignore-case --glob=\"*.org\" ."
  ;;               "tag1|tag2|tag9"
  ;;               "tag3|tag4|tag8"
  ;;               "(?=.*\\btag5\\b)(?=.*\\btag6\\b)(?=.*\\btag7\\b)"))

  ;; Extract NOT, OR, AND tags using regex
  (let* ((not-tags (if (string-match "~\\([^+|~]+\\)" query)
                       (match-string 1 query) ""))
         (or-tags  (if (string-match "|\\([^+|~]+\\)" query)
                       (match-string 1 query) ""))
         (and-tags (if (string-match "+\\([^+|~]+\\)" query)
                       (match-string 1 query) ""))

         ;; Convert extracted tags into the correct ripgrep format
         (not-part (if (string-empty-p not-tags) ""
                     (format "(?!.*\\b(?:%s)\\b)" 
                             (replace-regexp-in-string "," "|" not-tags))))

         (or-part (if (string-empty-p or-tags) ""
                    (format "(?=.*\\b(?:%s)\\b)" 
                            (replace-regexp-in-string "," "|" or-tags))))

         (and-part (if (string-empty-p and-tags) ""
                     (mapconcat (lambda (tag) (format "(?=.*\\b%s\\b)" tag))
                                (split-string and-tags ",") "")))

         ;; Construct final grep command    #\\+FILETAGS
         (rg-command (format "rg --pcre2 \"\\$:%s%s%s\" --line-number --ignore-case --glob=\"*.org\" ."
                             not-part or-part and-part)))

    ;; Execute grep with constructed query
    (grep rg-command))
  
  (cd (file-name-directory buffer-file-name))
  )


;; how do I create a special function that will rename this file after I've done some writing in it, so that the date and time identifier remains the same, and I will also want to create a function that for the file removes the tags from the file name, and appends new tags from the second line of the file that begins with #+FILETAGS: , 

;; @KEYBINDINGS


;; unbind in modal for shift + letter ??

(global-set-key (kbd "<f19>") #'__ToggleCommand) ;; this is caps lock, use Windows Power Tools to remap to f19
(global-set-key (kbd "<tab>") 'dabbrev-expand)

(define-key __MyKeymap (kbd "SPC") #'__ToggleInsert)
(define-key __MyKeymap (kbd "i") 'previous-line)
(define-key __MyKeymap (kbd "k") 'next-line)
(define-key __MyKeymap (kbd "j") 'backward-char)
(define-key __MyKeymap (kbd "l") 'forward-char)
(define-key __MyKeymap (kbd "J") 'left-word)
(define-key __MyKeymap (kbd "L") 'right-word)
(define-key __MyKeymap (kbd "I") #'(lambda () (interactive) (move-to-window-line 0) (previous-line)))
(define-key __MyKeymap (kbd "K") #'(lambda () (interactive) (move-to-window-line -1) (next-line)))
(define-key __MyKeymap (kbd "a") 'move-beginning-of-line)
(define-key __MyKeymap (kbd "e") 'move-end-of-line)
(define-key __MyKeymap (kbd "A") 'move-beginning-of-line)
(define-key __MyKeymap (kbd "E") 'move-end-of-line)
(define-key __MyKeymap (kbd "d") 'delete-char)
(define-key __MyKeymap (kbd "f") 'backward-delete-char)
(define-key __MyKeymap (kbd "D") #'__delete-word)
(define-key __MyKeymap (kbd "F") #'__backward-delete-word)
;;(define-key __MyKeymap (kbd "D") 'kill-word)
;;(define-key __MyKeymap (kbd "F") 'backward-kill-word)
(define-key __MyKeymap (kbd "s") 'newline)
(define-key __MyKeymap (kbd "S") 'open-line)
(define-key __MyKeymap (kbd "v") 'set-mark-command)
(define-key __MyKeymap (kbd "V") 'rectangle-mark-mode)
(define-key __MyKeymap (kbd "w") 'yank)
(define-key __MyKeymap (kbd "t") 'undo)
(define-key __MyKeymap (kbd "c") 'kill-ring-save)
(define-key __MyKeymap (kbd "C") 'kill-region)
(define-key __MyKeymap (kbd "r") 'kill-line)
(define-key __MyKeymap (kbd "R") '__duplicate-line)
(define-key __MyKeymap (kbd "g") 'recenter-top-bottom)
;;(define-key __MyKeymap (kbd "g") 'keyboard-quit)
(define-key __MyKeymap (kbd "b") (kbd "C-u C-SPC")) ;; pop mark
(define-key __MyKeymap (kbd "B") 'pop-global-mark)
(define-key __MyKeymap (kbd "<tab>") 'indent-for-tab-command)
(define-key __MyKeymap (kbd "q") 'other-window)
(define-key __MyKeymap (kbd "z") 'execute-extended-command)
(define-key __MyKeymap (kbd "u") 'isearch-forward)
(define-key __MyKeymap (kbd "U") 'isearch-backward)
(define-key __MyKeymap (kbd "m") 'replace-string)
(define-key __MyKeymap (kbd "M") 'string-insert-rectangle)
(define-key __MyKeymap (kbd "h") 'switch-to-buffer)
(define-key __MyKeymap (kbd "H") #'(lambda () (interactive) (switch-to-buffer (other-buffer))))
(define-key __MyKeymap (kbd "y") 'find-file)
(define-key __MyKeymap (kbd "o") 'imenu)
(define-key __MyKeymap (kbd ";") 'comment-line)
(define-key __MyKeymap (kbd "n") 'next-error)
(define-key __MyKeymap (kbd "N") 'previous-error)
(define-key __MyKeymap (kbd "`") '__clean-system-buffers)
(define-key __MyKeymap (kbd "=") 'quick-calc)

(define-key __MyKeymap (kbd "x c") '__compile)

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
(define-key __MyKeymap (kbd "x m a") '__save-all)
(define-key __MyKeymap (kbd "x m o") 'occur)

(define-key __MyKeymap (kbd "x e m") 'query-replace)
(define-key __MyKeymap (kbd "x e i") 'beginning-of-buffer)
(define-key __MyKeymap (kbd "x e k") 'end-of-buffer)
(define-key __MyKeymap (kbd "x e h") 'delete-horizontal-space)

(define-key __MyKeymap (kbd "x w d") 'split-window-below)
;; (define-key __MyKeymap (kbd "x w r") 'split-window-right) ;; actually don't need this just use the lambda one instead
(define-key __MyKeymap (kbd "x w c") 'delete-other-windows)
(define-key __MyKeymap (kbd "x w q") 'delete-window)
(define-key __MyKeymap (kbd "x w r") #'(lambda () (interactive) (delete-other-windows)(split-window-right)))

;; (define-key __MyKeymap (kbd "x g g") '__grep)
;; (define-key __MyKeymap (kbd "x g b") '__grep-current-buffer-only)
(define-key __MyKeymap (kbd "x g g") '__ripgrep)
(define-key __MyKeymap (kbd "x g b") '__ripgrep-current-buffer-only)

(define-key __MyKeymap (kbd "x f g p") ':git-push)

(define-key __MyKeymap (kbd "x q r") ':quick-run)
(define-key __MyKeymap (kbd "x q s") ':quick-save)
(define-key __MyKeymap (kbd "x q l") ':quick-load)

(define-key __MyKeymap (kbd "x p n") ':project-new)
(define-key __MyKeymap (kbd "x p s") ':project-switch)

(define-key __MyKeymap (kbd "x n g") ':note-create-in-general)
(define-key __MyKeymap (kbd "x n n") ':note-create-in-arena)
(define-key __MyKeymap (kbd "x n r") ':note-rename)
(define-key __MyKeymap (kbd "x n t") ':note-tagfile)
(define-key __MyKeymap (kbd "x n g") ':note-ripgrep)
(define-key __MyKeymap (kbd "x n s") ':note-tagsearch)

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
;; ? on command in minibuffer to show possible completions
;; SPC for M-f autocompletes
;; you can change font size with mouse wheel, and in the buffer border you can see offset from original
;; ???? ~ back-to-indentation
;; M-g g ~ goto-line
;; occur-rename-buffer is basically wgrep
;; can press Q on a lot of emacs' buffers to close them instantly

;; from old __save-all (although the let and inhibit-message doesn't work...)
;; (setq current-prefix-arg '(!))
;; (let ((inhibit-message t)) (call-interactively 'save-some-buffers))

