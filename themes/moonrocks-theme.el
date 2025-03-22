(deftheme moonrocks "Protons, neutrons, I ate a rock from the Moon.")

(defun myface (name &rest args)
  (list name `((t, args)) )
  )

(let
    (
     ;; R 1 G 1 B == beige
     ;; R 1 G 2 B == almond beige
     ;; R 1 G 2.5 B == soft beige
     ;; R 2 G 2 B == cocoa beige (not great, a lot of red)
     ;; R 2 G 3 B == sepia
     ;; R 1 G 3 B == wheat
     
     ;; bad: R 2 G 1 B
     ;; R 3 G 3 B (not great, a lot of red)

     ;; F8E8C0 : R 1   G 2.5 B
     ;; F8E8B8 : R 1.5 G 2.5 B

     
     ;;F8D8A8 sepia
     ;; E8D8C0 soft beige
     ;;F6D5B8 light cream
     ;; F5E6C8 2soft beige
     ;; F0E4D0 warm sand     not really red enough
     ;; F8E7C2 almond beige
     ;;       F6DFC2 desert sand
     ;;F8E3B5 golden wheat
     ;;F7D9A7 soft ochre
     ;; F6D7B8 cocoa beige
     ;; E8D8B8
     
     ;; D4A373 muted gold
     ;; BF6C37 dusty orange
     
     ;; E65100
     ;; af7800
     
     ;; 753B10 good contrast with bg, bad with fg
     ;; 882F10 good contrast with bg, decent enough with fg
     ;; A02F2F 862f2f
     ;; 5E3F78
     ;; 941e1a
     ;; 2D534D
     ;; 5C7333
     ;; 23571e
     ;; 00555e 005466

     ;; this R,G, blue range and up is good (but fg??): 080A38
     (bg "#F8E8B8") ;; E8D8C0        000040 080A40   080A3C
     (fg "#4A2A1F") ;; 000000     AB8874             9B7874            AB7864 A88D8A 9E9F88   CBB390 D04040
     (keyword "#3A1A0F") ;; C33333              D33E43 C3332A C33333
     (type "#4A2A1F") ;; 639FAB
     (literal "#941e1a") ;; 4B9211
     (comment "#941e1a") ;; 807D8C                       666370 807D8C 8B8896     767382     968AA2 908AA0 8A90A0 908AA0 908898

     (region_bg "#AAAA66") ;;     02414F 30405A
     (caret "#780000") ;; A98949           CCCCCC BABABA

     (modeline "#E0BC80") ;; D8C8B0       021140
     (modeline_active "#E0BC80") ;;D88C50     C8B8A0         122150
     (modeline_fg "#38232A") ;; 8B7B72          8B8B72            989888 7B7B6B
     
     (red "#AA0000")
     (green "#00AA00")
     (blue "#0000AA")
     (orange "#AA8000")
     )

  (custom-theme-set-faces `moonrocks
                          
                          (myface 'default :background bg :foreground fg)
                          (myface 'bold :foreground fg :bold t)
                          (myface 'italic :foreground fg :italic t)
                          (myface 'bold-italic :foreground fg :bold t :italic t)
                          (myface 'underline :inherit 'default :underline t)
                          (myface 'custom-face-tag :inherit 'default)
                          (myface 'custom-state :inherit 'default)
                          (myface 'fringe :inherit 'default)
                          (myface 'vertical-border :foreground modeline :background modeline)
                          (myface 'internal-border :foreground modeline :background modeline)

                          (myface 'font-lock-builtin-face :inherit 'default)
                          (myface 'font-lock-variable-name-face :inherit 'default)
                          (myface 'font-lock-function-name-face :inherit 'default)
                          (myface 'font-lock-comment-delimiter-face :foreground comment)
                          (myface 'font-lock-comment-face :foreground comment)
                          (myface 'font-lock-constant-face :inherit 'default)
                          (myface 'font-lock-keyword-face :foreground keyword :bold t)
                          (myface 'font-lock-preprocessor-face :foreground keyword :bold t)
                          (myface 'font-lock-string-face :foreground literal)
                          (myface 'font-lock-type-face :foreground type)
                          (myface 'font-lock-warning-face :foreground red)

                          ;; (myface 'success :foreground green)
                          ;; (myface 'error :foreground red)
                          ;; (myface 'warning :foreground orange)

                          (myface 'highlight :background region_bg)
                          (myface 'cursor :background caret)
                          (myface 'region :background region_bg)

                          (myface 'mode-line :background modeline_active :foreground modeline_fg)
                          (myface 'mode-line-buffer-id :foreground modeline_fg)
                          (myface 'mode-line-inactive :background modeline :foreground modeline_fg)
                          (myface 'mode-line-emphasis :background modeline :foreground modeline_fg)
                          (myface 'mode-line-highlight :background modeline :foreground modeline_fg)
                          (myface 'gui-element :background modeline :foreground modeline_fg)
                          (myface 'minibuffer-prompt :foreground type)

                          ;; wgrep (SlateGray1)

                          ;; (myface 'match :foreground bg :background green :inverse-video nil)
                          ;; (myface 'isearch :foreground fg :background green)
                          ;; (myface 'lazy-highlight :foreground fg :background green :inverse-video nil)
                          ;; (myface 'isearch-fail :background red :inverse-video t)



                          ;; `(org-agenda-structure ((,class (:foreground ,aqua :bold t))))
                          ;; `(org-agenda-date ((,class (:foreground ,blue :underline nil))))
                          ;; `(org-agenda-done ((,class (:foreground ,green))))
                          ;; `(org-agenda-dimmed-todo-face ((,class (:foreground ,comment))))
                          ;; `(org-block ((,class (:foreground ,green :background ,far-background :extend t))))
                          ;; `(org-block-background ((,t (:background ,far-background :extend t))))
                          ;; `(org-column ((,class (:background ,current-line))))
                          ;; `(org-column-title ((,class (:inherit org-column :weight bold :underline t))))
                          ;; `(org-document-info ((,class (:foreground ,aqua :height 1.35))))
                          ;; `(org-document-info-keyword ((,class (:foreground ,green :height 1.35))))
                          ;; `(org-document-title ((,class (:weight bold :foreground ,foreground :height 1.35))))
                          ;; `(org-ellipsis ((,class (:foreground ,comment))))
                          ;; `(org-footnote ((,class (:foreground ,aqua))))
                          ;; `(org-formula ((,class (:foreground ,red))))
                          ;; `(org-special-keyword ((,class (:foreground ,comment))))
                          ;; `(org-table ((,class (:foreground ,"#e3f2fd" :background ,far-background))))
                          ;; `(org-block-begin-line ((,class (:foreground ,"#b3e5fc" :background "#1e2930"
                          ;;                                              :box (:style released-button) :extend t))))
                          ;; `(org-block-end-line ((,class (:foreground ,"#b3e5fc" :background "#1e2930"
                          ;;                                            :box (:style released-button) :extend t))))
                          ;; `(org-kbd ((,class (:background ,inactive-gray :foreground ,foreground
                          ;;                                 :box (:line-width 1 :color nil :style pressed-button)))))


                          ;; `(org-done ((,class (:foreground ,green :bold t :background,"#1b5e20"))))
                          ;; `(org-todo ((,class (:foreground ,"#ffab91" :bold t :background ,"#dd2c00"))))
                          ;; `(org-upcoming-deadline ((,class (:foreground ,orange))))
                          ;; `(org-warning ((,class (:weight bold :foreground ,red))))
                          ;; `(org-date ((,class (:foreground ,"#80cbc4" :underline t))))
                          ;; `(org-scheduled ((,class (:foreground ,green))))
                          ;; `(org-scheduled-previously ((,class (:foreground ,orange))))
                          ;; `(org-scheduled-today ((,class (:foreground ,green))))
                          ;; `(org-code ((,class (:foreground ,green :background ,far-background))))
                          ;; `(org-link ((,class (:foreground ,blue :underline t))))
                          
                          ;; (myface 'org-hide :foreground "transparent" :background bg)
                          
                          ;; org-verbatim :weight 'bold   :slant 'italic
                          
                          (myface 'org-level-1 :foreground keyword :bold t :height 1.3)
                          (myface 'org-level-2 :foreground keyword :bold t :height 1.2)
                          (myface 'org-level-3 :foreground keyword :bold t :height 1.1)
                          (myface 'org-level-4 :foreground keyword :bold t)
                          (myface 'org-level-5 :foreground keyword :bold t)
                          (myface 'org-level-6 :foreground keyword :bold t)
                          (myface 'org-level-7 :foreground keyword :bold t)
                          (myface 'org-level-8 :foreground keyword :bold t)
                          (myface 'org-level-9 :foreground keyword :bold t)
                          
                          (myface 'org-headline-done :foreground fg :bold nil)
                          ;; this doesn't work because org doesn't define it
                          ;; so you would have to define it yourself
                          ;; similar to how you would highlight TODO in comments
                          ;; of programming languages, with regexp...
                          ;; (myface 'org-headline-todo :foreground fg)
                          (myface 'org-tag :foreground comment :italic t :bold nil)
                          ;; (myface 'org-underline :foreground fg :underline t)

                          ;; (myface 'org-latex-preview :foreground fg :italic t :bold t :height 1.5 :family "Courier New")
                          ;; `(org-latex-preview ((t (:foreground "black" :weight bold :background "lightgray"))))
                          
                          )
  )

(provide-theme 'moonrocks)
