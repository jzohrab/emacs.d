(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(package-selected-packages (quote (org-super-agenda helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'helm-config)
(helm-mode 1)


(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'php-mode)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ORG MODE

;; https://github.com/sabof/org-bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook 'visual-line-mode)

;; Habits
(setq org-habit-show-habits-only-for-today t)
(setq org-habit-show-all-today nil)

;; View PDFs in org-mode with docview: links
(setq doc-view-ghostscript-program "/usr/local/bin/gs")
(setq doc-view-resolution 128)

;; per note in https://orgmode.org/manual/Activation.html, global keys:
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)


;; Capture templates
;; ref https://www.reddit.com/r/emacs/comments/7zqc7b/share_your_org_capture_templates/
(setq
 org-capture-templates
 '(
   ("t" "TODO" entry (file+headline "~/Dropbox/org/inbox.org" "Collect")
    "* TODO %? %^G \n  %U" :empty-lines 1)
   ("T" "Tickler" entry (file+headline "~/Dropbox/org/tickler.org" "Tickler")
    "* %i%? \n %U")
   ("s" "Scheduled TODO" entry (file+headline "~/Dropbox/org/inbox.org" "Collect")
    "* TODO %? %^G \nSCHEDULED: %^t\n  %U" :empty-lines 1)
   ("d" "Deadline" entry (file+headline "~/Dropbox/org/inbox.org" "Collect")
    "* TODO %? %^G \n  DEADLINE: %^t" :empty-lines 1)
   ("p" "Priority" entry (file+headline "~/Dropbox/org/inbox.org" "Collect")
    "* TODO [#A] %? %^G \n  SCHEDULED: %^t")
   ("r" "Reviews")
   ("rd" "Daily" entry (file "~/Dropbox/org/daily_reviews.org")
    (file "~/Dropbox/org/templates/daily_review.org"))
   )
)


;; org-super-agenda
(require 'org-super-agenda)
(org-super-agenda-mode)

;; Ref zaen323 example from
;; https://github.com/alphapapa/org-super-agenda/blob/master/examples.org

(setq org-agenda-custom-commands
      '(("z" "Super zaen view"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '(
			 (:name "Schedule" :time-grid t :order 1)
			 (:name "Habits" :habit t :order 3)
			 (:name "Today"
                                :time-grid t
                                :date today
                                :todo "TODAY"
                                :scheduled today
				:deadline today
                                :order 2)
			 (:name "Upcoming deadlines" :deadline t :order 100)
			 ))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next actions"
                                 :todo "NEXT"
                                 :order 1)
                          (:name "Important"
                                 :tag "Important"
                                 :priority "A"
                                 :order 6)
                          (:name "Lesser Importance"
                                 :priority<= "B"
                                 :order 7)
                          (:name "Due Soon"
                                 :deadline future
                                 :order 8)
                          (:name "Overdue"
                                 :deadline past
                                 :order 7)
                          (:name "Habits"
                                 :habit t
                                 :order 8)
                          (:name "Projects"
                                 :tag "Project"
                                 :order 14)
                          (:name "Emacs"
                                 :tag "Emacs"
                                 :order 13)
                          (:name "Research"
                                 :tag "Research"
                                 :order 15)
                          (:name "To read"
                                 :tag "Read"
                                 :order 30)
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 20)
                          (:name "trivial"
                                 :priority<= "C"
                                 :tag ("Trivial" "Unimportant")
                                 :todo ("SOMEDAY" )
                                 :order 90)
                          ))))))))


;; More capture shortcuts
;; ref http://pragmaticemacs.com/emacs/a-shorter-shortcut-to-capture-todo-tasks/
(defun my-org-capture-todo ()
  (interactive)
  "Capture a TODO item"
  (org-capture nil "t"))

;; bind
(define-key global-map (kbd "C-t") 'my-org-capture-todo)

;; Tried styling per https://zzamboni.org/post/beautifying-org-mode-in-emacs/,
;; didn't care for it though.

;; Smaller graphs in agenda.
;; ref https://orgmode.org/manual/Tracking-your-habits.html
(setq org-habit-graph-column 65)
(setq org-habit-preceding-days 10)
(setq org-habit-following-days 1)

;; ref http://www.newartisans.com/2007/08/using-org-mode-as-a-day-planner/
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-show-all-dates t)

(setq org-agenda-files '("~/Dropbox/org/inbox.org"
                         "~/Dropbox/org/gtd.org"
			 "~/Dropbox/org/habits.org"
                         "~/Dropbox/org/tickler.org"))

;; Allow top-level refiling.  This is trickier using Helm,
;; see https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)

(setq org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 1)
                           ("~/Dropbox/org/habits.org" :maxlevel . 1)
                           ("~/Dropbox/org/someday.org" :maxlevel . 1)
                           ("~/Dropbox/org/reference.org" :maxlevel . 1)
			   ("~/Dropbox/org/tickler.org" :maxlevel . 1)))

;; ref https://orgmode.org/manual/TODO-dependencies.html
;; if project has the following, open TODOs block subsequent ones:
;;   :PROPERTIES:
;;   :ORDERED:  t
;;   :END:
(setq org-enforce-todo-dependencies t)
(setq org-agenda-dim-blocked-tasks 'invisible)

(setq org-list-description-max-indent 5)
(setq org-ellipsis " ▼")

(setq initial-buffer-choice
      (lambda ()
	(org-agenda nil "z")
	(delete-other-windows)
	(get-buffer "*Org Agenda*")
	)
      )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; keybindings
(global-set-key "\C-ch" 'query-replace)
(global-set-key "\C-cr" 'query-replace-regexp)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun do-count-words (start end)
	"Print number of words in the region."
	(interactive "r")
	(save-excursion
		(save-restriction
			(narrow-to-region start end)
			(goto-char (point-min))
			(count-matches "\\sw+"))))
(defun wc () (interactive) (message (number-to-string (do-count-words (point-min) (point-max)))))
(global-set-key "\C-cw" 'wc)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer 'disabled nil)
(setq backup-directory-alist `(("." . "~/.saves")))
(setq ispell-program-name "/usr/local/Cellar/ispell/3.3.02/bin/ispell")
