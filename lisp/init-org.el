;;
;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;;
;; TODO---(C-c C-t)--(SPC)
;;
;; 1.Fast access to TODO states
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" ))))
;; If press C-c C-t and t,n.., it will change an entry to an arbitrary TODO state(like:t-todo,n-next-----).
;; SPC can be used to remove any TODO keyword from an entry. 

;; 2.Faces for TODO keywords (colors)
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
;; 3.Progress logging
(setq org-log-done 'note)


;; Tags
;; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@personal" . ?p)
                            ("@office" . ?o)
                            ("@learn" . ?l)
                            (:endgroup)
                            ("WAITING" . ?w)
                            ("HOLD" . ?h)
                            ("WORK" . ?W)
                            ("FARM" . ?F)
                            ("ORG" . ?O)
                            ("NORANG" . ?N)
                            ("crypt" . ?E)
                            ("NOTE" . ?n)
                            ("CANCELLED" . ?c)
                            ("FLAGGED" . ??))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)










;;
;; Capture----capture new ideas,tasks,and store notes
;;

;; sets a default target file for notes
(setq org-directory "~/cnm")
(setq org-default-notes-file "~/git/org/refile.org")


;; defines a global key for capturing new material
;; use C-c c to start capture mode(this keybinding is global and not active by default: so, need to install it.)
(global-set-key (kbd "C-c c") 'org-capture)

;; Capture templates
;; it's for capturing new ideas and tasks,store notes
;; * TODO %?\n %i\n %a"
;; %?  After completing the template, position cursor here.==在编辑模板时，光标的起始位置。（完全打印空格）（"* TODO %?\n ")
;; %i  Initial content, the region when capture is called while the region is active.The entire text will be indented like %i itself.最初的 内容;;;     ，部位当capture 被写，被命名   整个text缩进排印  
;; %a  Annotation, normally the link created with org-store-link.==During expansion of the template, %a has been replaced by a link to the locati;;     on fromwhere you called the capture command. ==光标所在位置press 'c-c c'时，编辑完，press'c-c c-c',会indent（缩进）print 光标处的entry名。;;    （* TODO %?\n %i\n %a"） 若光标处无entry，则无。
;; %u/U Like the above, but inactive timestamps.加当前时间戳
;; %f  File visited by current buffer when org-capture was called.
;; %:keyword  Specific information for certain link types, see below.
;; %^g  Prompt for tags, with completion on tags in target file



(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/cnm/refile.org" )
               "* TODO %? :TASKS:\n%a\n" :clock-in t :clock-resume t)
	      ("n" "note" entry (file "~/cnm/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("i" "idea" entry (file+headline "~/cnm/refile.org" "idea")
               "* %? :IDEA:\nEntered on%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/cnm/refile.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("p" "Plan" entry (file+datetree "~/cnm/refile.org")
               "* NEXT %? view[%] :PLAN:\nEntered on%t\n" :clock-in t :clock-resume t))))


;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
;; 
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;; refile

;; 自动显示文件路径
;; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)



;; agenda


(setq org-agenda-files (quote ("~/cnm"
                               "~/cnm/ks")))
;; press c-c a C to config
;; { "key" "description" [ (agenda "")(tape "match") ] [setting (opt1 val1) (opt2 val2) ....] files }
(setq org-agenda-custom-commands 
      '(("N" "Notes" tags "NOTE"
         ((org-agenda-overriding-header "Notes")
          (org-tags-match-list-sublevels t)))
        ("t" "Agenda" tags "REFILE"
        ((org-agenda-overriding-header "Suck Tasks")
         (org-tags-match-list-sublevels t)))
        (" " "Agenda" 
         ((agenda) 
          (tags "REFILE"
           ((org-agenda-overriding-header "Tasks to Refile")  
            (org-tags-match-list-sublevels nil)))))))
                    


;; Enable display of the time grid so we can see the marker for the current time
(setq org-agenda-time-grid (quote ((daily today remove-match)
                                   #("------------------" 0 18 (org-heading t))
                                   (0800 0930 1100 1200 1400 1530 1700 1800 2000 ))))

(setq org-agenda-span 'day)


;; Clock Setup
;;




;;




;; Custom time format











(provide 'init-org)




