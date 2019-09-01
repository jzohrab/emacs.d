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

(setq org-super-agenda-groups
      '(;; Each group has an implicit boolean OR operator between its selectors.
	(:name "Today"  ; Optionally specify section name
	       :time-grid t  ; Items that appear on the time grid
	       :todo "TODAY")  ; Items that have this TODO keyword
	(:name "Important"
	       ;; Single arguments given alone
	       :tag "bills"
	       :priority "A")
	;; Set order of multiple groups at once
	(:order-multi (2 (:name "Shopping in town"
				;; Boolean AND group matches items that match all subgroups
				:and (:tag "shopping" :tag "@town"))
			 (:name "Food-related"
				;; Multiple args given in list with implicit OR
				:tag ("food" "dinner"))
			 (:name "Personal"
				:habit t
				:tag "personal")
			 (:name "Space-related (non-moon-or-planet-related)"
				;; Regexps match case-insensitively on the entire entry
				:and (:regexp ("space" "NASA")
					      ;; Boolean NOT also has implicit OR between selectors
					      :not (:regexp "moon" :tag "planet")))))
	;; Groups supply their own section names when none are given
	(:todo "WAITING" :order 8)  ; Set order of this section
	(:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
	       ;; Show this group at the end of the agenda (since it has the
	       ;; highest number). If you specified this group last, items
	       ;; with these todo keywords that e.g. have priority A would be
	       ;; displayed in that group instead, because items are grouped
	       ;; out in the order the groups are listed.
	       :order 9)
	(:priority<= "B"
		     ;; Show this section after "Today" and "Important", because
		     ;; their order is unspecified, defaulting to 0. Sections
		     ;; are displayed lowest-number-first.
		     :order 1)
	;; After the last group, the agenda will display items that didn't
	;; match any of these groups, with the default order position of 99
	))

(setq org-agenda-span 1)

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

(setq initial-buffer-choice "~/Dropbox/org/gtd.org")

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
