(deftheme simplecoder "It's just simple stuff.")

(defun myface (name &rest args)
  (list name `((t, args)) )
  )

(let
    (
     (bg "#d8c8c8") ;; e0b8b8 e0c8c8 d0c0c0
     (fg "#2A0A00") ;; 3A1A10
     (keyword "#3C2050") ;; 4C3060
     (type "#104040") ;; 205050
     (function "#2A0A00") ;; 3A1A10
     (variable "#603020") ;; 704030
     (preproc "#504010") ;; 605020
     (literal "#452301") ;; 553311
     (comment "#103D20") ;; 204D30
     
     (region_bg "#e0e0e0")
     (caret "#305030") ;; af8700
     (hl_line "#c0c0c0")

     (modeline "#a09090") ;; a0a080
     (modeline_active "#80a040") ;; a0d060
     (fringe "#a09090") ;; a88878 b09080
     (bufferid "#988878") ;; c09898
     (border "#404020") ;; a0d060 
     
     (red "#aa0000")
     (green "#00aa00")
     (blue "#0000aa")
     (orange "#aa8000")
     )

  (custom-theme-set-faces `simplecoder
                          
                          (myface 'default :background bg :foreground fg)
                          (myface 'bold :foreground fg :bold t)
                          (myface 'italic :foreground fg :italic t)
                          (myface 'bold-italic :foreground fg :bold t :italic t)
                          (myface 'underline :inherit 'default)
                          (myface 'custom-face-tag :inherit 'default)
                          (myface 'custom-state :inherit 'default)
                          (myface 'fringe :background fringe)
                          (myface 'vertical-border :foreground border :background border)
                          (myface 'internal-border :foreground border :background border)

                          (myface 'font-lock-builtin-face :inherit 'default)
                          (myface 'font-lock-variable-name-face :foreground variable)
                          (myface 'font-lock-function-name-face :foreground function)
                          (myface 'font-lock-comment-delimiter-face :foreground comment)
                          (myface 'font-lock-comment-face :foreground comment)
                          (myface 'font-lock-constant-face :inherit 'default)
                          (myface 'font-lock-keyword-face :foreground keyword)
                          (myface 'font-lock-preprocessor-face :foreground preproc)
                          (myface 'font-lock-string-face :foreground literal)
                          (myface 'font-lock-type-face :foreground type)
                          (myface 'font-lock-warning-face :foreground red)

                          ;; (myface 'success :foreground green)
                          ;; (myface 'error :foreground red)
                          ;; (myface 'warning :foreground orange)

                          (myface 'highlight :background region_bg)
                          (myface 'hl-line :background hl_line)
                          (myface 'cursor :background caret)
                          (myface 'region :background region_bg)

                          (myface 'mode-line :background modeline_active :foreground fg :box '(:line-width -1 :color "#553311"))
                          (myface 'mode-line-buffer-id :background bufferid :foreground fg :bold t)
                          (myface 'mode-line-inactive :background modeline :foreground fg)
                          (myface 'mode-line-emphasis :background modeline :foreground fg)
                          (myface 'mode-line-highlight :background modeline :foreground fg)
                          (myface 'gui-element :background modeline :foreground fg)
                          (myface 'minibuffer-prompt :foreground type)

                          (myface 'org-level-1 :foreground keyword :bold t)
                          (myface 'org-level-2 :foreground keyword :bold t)
                          (myface 'org-level-3 :foreground keyword :bold t)
                          (myface 'org-level-4 :foreground keyword :bold t)
                          (myface 'org-level-5 :foreground keyword :bold t)
                          (myface 'org-level-6 :foreground keyword :bold t)
                          (myface 'org-level-7 :foreground keyword :bold t)
                          (myface 'org-level-8 :foreground keyword :bold t)
                          (myface 'org-level-9 :foreground keyword :bold t)
                          
                          ;; wgrep (SlateGray1)
                          )
  )

(provide-theme 'simplecoder)
