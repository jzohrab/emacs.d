(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(package-selected-packages (quote (magit org-gcal org-journal org-super-agenda helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-tag ((t (:foreground "green4" :weight bold)))))


(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'helm-config)
(helm-mode 1)


(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'php-mode)


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ORG MODE

;; org-gcal sync
;; ref https://cestlaz.github.io/posts/using-emacs-26-gcal/
;; Manually sync the calendar with C-cg 

(require 'org-gcal)

;; Storing my creds in a secret file so I don't commit them here.
(require 'json)
(defun get-gcal-config-value (key)
  "Return the value of the json file gcal_secret for key"
  (cdr (assoc key (json-read-file "~/.emacs.d/gcal-secret.json")))
  )

(setq org-gcal-client-id (get-gcal-config-value 'org-gcal-client-id)
      org-gcal-client-secret (get-gcal-config-value 'org-gcal-client-secret)
      org-gcal-file-alist '(("jzohrab@gmail.com" . "~/Dropbox/org/schedule.org")))

(defun jz/org-gcal-sync ()
  "Replace existing schedule file with blank, and then resync"
  (interactive)
  (write-region "" nil "~/Dropbox/org/schedule.org")
  (org-gcal-sync)
  )

(global-set-key "\C-cg" 'jz/org-gcal-sync)





;; https://github.com/sabof/org-bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook 'visual-line-mode)

;; Journaling
(setq org-journal-dir "~/Dropbox/org/journal/")
(require 'org-journal)

(setq org-tag-alist '(("@computer" . ?c) ("@guitar" . ?g) ("@phone" . ?p) ("@sherry" . ?s)))
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "APPT(a)" "|" "DONE(d)" "CANCELLED(c)" "DEFERRED(f)")))
(setq org-log-into-drawer "LOGBOOK")

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
   ("s" "Someday" entry (file "~/Dropbox/org/someday.org")
    "* %i%? \n %U")
   ("t" "TODO" entry (file "~/Dropbox/org/inbox.org")
    "* TODO %? \n  %U" :empty-lines 1)
   ("T" "Tickler" entry (file "~/Dropbox/org/tickler.org")
    "* %i%? \n %U")
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
      '(
	("z" "Super zaen view"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '(
			 (:name "Schedule (C-c g to refresh google cal data, then g)" :time-grid t :order 1)
			 (:name "Money" :tag "money" :order 2)
			 ;; (:name "Guitar" :tag "guitar")
			 ;; (:name "Exercise" :tag "exercise")
			 ;; (:name "Spanish" :tag "spanish")
			 ;; (:name "Flexibility" :tag "flexibility")))
			 (:name "Upcoming deadlines" :deadline t :order 100)
			 (:name "Today (M-x org-revert-all-org-buffers to reload files)"
                                :date t
                                :scheduled today
				:scheduled past
				:deadline today
				:deadline past
                                :order 2)
			 ))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next actions"
                                 :todo "NEXT"
                                 :order 2)
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
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 1)
                          (:name "trivial"
                                 :priority<= "C"
                                 :tag ("Trivial" "Unimportant")
                                 :todo ("SOMEDAY" )
                                 :order 90)
                          )))))  ;; end of ((agenda ...
	 (( org-agenda-files '("~/Dropbox/org/inbox.org"
                         "~/Dropbox/org/gtd.org"
			 "~/Dropbox/org/habits.org"
                         "~/Dropbox/org/tickler.org"
			 "~/Dropbox/org/schedule.org") ))

	 )  ;; end ("z" "super zaen view"

	("g" "Guitar"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '(
			 (:name "Today (M-x org-revert-all-org-buffers to reload files)"
                                :date t
                                :scheduled today
				:scheduled past
				:deadline today
				:deadline past
                                :order 1)
			 ))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next"
                                 :todo "NEXT"
                                 :order 2)
                          )))))  ;; end of ((agenda ...
	 (( org-agenda-files '("~/Dropbox/org/guitar.org")))
	 )  ;; end guitar
	
	("p" "Spanish"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '(
			 (:name "Today (M-x org-revert-all-org-buffers to reload files)"
                                :date t
                                :scheduled today
				:scheduled past
				:deadline today
				:deadline past
                                :order 1)
			 ))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next"
                                 :todo "NEXT"
                                 :order 2)
                          )))))  ;; end of ((agenda ...
	 (( org-agenda-files '("~/Dropbox/org/spanish.org")))
	 ) ;; end spanish
	
 	("f" "Fitness"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '(
			 (:name "Today (M-x org-revert-all-org-buffers to reload files)"
                                :date t
                                :scheduled today
				:scheduled past
				:deadline today
				:deadline past
                                :order 1)
			 ))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next"
                                 :todo "NEXT"
                                 :order 2)
                          )))))  ;; end of ((agenda ...
	 (( org-agenda-files '("~/Dropbox/org/fitness.org")))

	 )  ;; end fitness
	
	)
      )


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
                         "~/Dropbox/org/guitar.org"
                         "~/Dropbox/org/spanish.org"
                         "~/Dropbox/org/fitness.org"
			 "~/Dropbox/org/habits.org"
                         "~/Dropbox/org/tickler.org"
			 "~/Dropbox/org/schedule.org"))

;; Allow top-level refiling.  This is trickier using Helm,
;; see https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)

(setq org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 1)
                           ("~/Dropbox/org/guitar.org" :maxlevel . 1)
                           ("~/Dropbox/org/spanish.org" :maxlevel . 1)
                           ("~/Dropbox/org/fitness.org" :maxlevel . 1)
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

;; Resetting checkboxes when done
;; https://orgmode.org/worg/org-contrib/org-checklist.html
(require 'org-checklist)

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
(global-set-key (kbd "C-x g") 'magit-status)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/toggle-spanish-characters ()
    "Enable/disable alt key to allow insert spanish characters."
    (interactive)
    (if (eq ns-alternate-modifier 'meta)
        (progn
	 (setq ns-alternate-modifier nil)
	 (message "Spanish chars ON (OPT+e => ´; OPT+n => ~)")
	 )
      (progn
       (setq ns-alternate-modifier 'meta)
       (message "Spanish chars OFF")
       )
    ))

(global-set-key "\C-cs" 'my/toggle-spanish-characters)

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
