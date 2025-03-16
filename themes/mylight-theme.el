(deftheme mylight "My light theme for C/C++")

(defun myface (name &rest args)
  (list name `((t, args)) )
  )

(let
    (
     (bg "#F6F6F6")
     (fg "#000000")
     (keyword "#FF0000")
     (type "#0000FF")
     (literal "#008888")
     (comment "#007700")
     
     (region_bg "#EEDC82")
     (caret "#000000") 
     (hl_line "#B4EEB4") 

     (modeline "#E5E5E5")
     (modeline_active "#BFBFBF")
     
     (red "#FF0000")
     (green "#228B22")
     (blue "#0000FF")
     (orange "#FF8C00")
     )

  (custom-theme-set-faces `mylight
                          
                          (myface 'default :background bg :foreground fg)
                          (myface 'bold :foreground fg)
                          (myface 'italic :foreground fg)
                          (myface 'bold-italic :foreground fg)
                          (myface 'underline :inherit 'default)
                          (myface 'custom-face-tag :inherit 'default)
                          (myface 'custom-state :inherit 'default)
                          (myface 'fringe :inherit 'default)
                          (myface 'vertical-border :foreground modeline_active :background modeline_active)
                          (myface 'internal-border :foreground modeline_active :background modeline_active)

                          (myface 'font-lock-builtin-face :inherit 'default)
                          (myface 'font-lock-variable-name-face :inherit 'default)
                          (myface 'font-lock-function-name-face :inherit 'default)
                          (myface 'font-lock-comment-delimiter-face :foreground comment)
                          (myface 'font-lock-comment-face :foreground comment)
                          (myface 'font-lock-constant-face :inherit 'default)
                          (myface 'font-lock-keyword-face :foreground keyword)
                          (myface 'font-lock-preprocessor-face :foreground keyword)
                          (myface 'font-lock-string-face :foreground literal)
                          (myface 'font-lock-type-face :foreground type)
                          (myface 'font-lock-warning-face :foreground red)

                          (myface 'success :foreground green)
                          (myface 'error :foreground red)
                          (myface 'warning :foreground orange)

                          (myface 'highlight :background region_bg)
                          (myface 'hl-line :background hl_line)
                          (myface 'cursor :background caret)
                          (myface 'region :background region_bg)

                          (myface 'mode-line :background modeline_active :foreground fg)
                          (myface 'mode-line-buffer-id :foreground fg)
                          (myface 'mode-line-inactive :background modeline :foreground fg)
                          (myface 'mode-line-emphasis :background modeline :foreground fg)
                          (myface 'mode-line-highlight :background modeline :foreground fg)
                          (myface 'gui-element :background modeline :foreground fg)
                          (myface 'minibuffer-prompt :foreground type)

                          ;; wgrep (SlateGray1)

                          ;; (myface 'match :foreground bg :background green :inverse-video nil)
                          ;; (myface 'isearch :foreground fg :background green)
                          ;; (myface 'lazy-highlight :foreground fg :background green :inverse-video nil)
                          ;; (myface 'isearch-fail :background red :inverse-video t)
                          
                          )
  )

(provide-theme 'mylight)
