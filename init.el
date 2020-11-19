(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doc-view-continuous t)
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(package-selected-packages
   (quote
    (org doom-themes treemacs-persp treemacs-magit treemacs-icons-dired treemacs-projectile use-package treemacs magit org-gcal org-journal org-super-agenda helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-tag ((t (:foreground "green4" :weight bold)))))

;; Start emacsclient so opening other text files via Finder
;; runs in same emacs session.
(server-start)

(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'helm-config)
(helm-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'php-mode)


;; ido, and adding the 'dot' lets you pick a directory.
(ido-mode)
(setq ido-show-dot-for-dired t)

(require 'use-package)

;; ;; ;;;;;;;;;;;;;;;;;;;;;
;; DOOM THEME

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-opera-light t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  
  ;; (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; TREEMACS
;;

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 t
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    (treemacs-resize-icons 14)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;;(use-package treemacs-evil
;;  :after treemacs evil
;;  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package treemacs-persp
   :after treemacs persp-mode
   :ensure t
   :config (treemacs-set-scope-type 'Perspectives))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; js
;; https://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode
(setq js-indent-level 2)

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

;; Reloading buffers periodically, b/c I work with beorg.
;; https://stackoverflow.com/questions/1480572/
;;   how-to-have-emacs-auto-refresh-all-buffers-when-files-have-changed-on-disk
(global-auto-revert-mode t)

;; https://github.com/sabof/org-bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook 'visual-line-mode)

;; Journaling
(setq org-journal-dir "~/Dropbox/org/journal/")
(require 'org-journal)

(setq org-tag-alist '(("@computer" . ?c) ("@phone" . ?p) ("@sherry" . ?s)))
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
    "* %i%?")
   ("v" "Vocab" entry (file "~/Dropbox/org/inbox.org")
    (file "~/Dropbox/org/templates/srs_review.org"))
   ("t" "TODO" entry (file "~/Dropbox/org/inbox.org")
    "* TODO %?")
   ("T" "Tickler" entry (file "~/Dropbox/org/tickler.org")
    "* %i%?")
   ("r" "Reviews")
   ("rd" "Daily" entry (file "~/Dropbox/org/daily_reviews.org")
    (file "~/Dropbox/org/templates/daily_review.org"))
   )
)

;; org-super-agenda
(require 'org-super-agenda)
(org-super-agenda-mode)


;; Common agenda layout for major areas (guitar, spanish, fitness)
(defun my-common-agenda-command (command description file)
  `(,command ,description
	     ((agenda "" ((org-agenda-span 'day)
			  (org-agenda-overriding-header ,description)
                      (org-super-agenda-groups
                       '(
			 (:discard (:tag "hold"))
			 (:auto-category t)
                         (:name "Today (M-x org-revert-all-org-buffers to reload files)"
                                :date t
                                :scheduled today
                                :scheduled past
                                :deadline today
                                :deadline past
                                :order 1)
                         ))))
;;          (alltodo "" ((org-agenda-overriding-header "")
;;                       (org-super-agenda-groups
;;                        '((:name "Next"
;;                                 :todo "NEXT"
;;                                 :order 2)
;;                          ))))
	  )  ;; end of ((agenda ...
	     ((org-agenda-files '(,file)))
	     )
  )


;; Ref https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html
;;   for more agenda tips.

;; https://www.masteringemacs.org/article/effective-editing-movement
;; nav by s-expression: C-M-f, C-M-b
(setq org-agenda-custom-commands
      `(
        ("z" "Master view!"
         (
	  ;; List big rocks, MITs at the top.
	  ;; https://zenhabits.net/big-rocks-first-double-your-productivity-this-week/
	  ;; https://zenhabits.net/purpose-your-day-most-important-task/
          (tags "bigrock|MIT" ((org-agenda-overriding-header "Big Rocks and MITs")
                       (org-super-agenda-groups
                        '(
                          (:name "MITs" :tag "MIT" :order 2)
                          (:name "Big rocks" :tag "bigrock" :order 1)
                          )
			)
		       ))

	  (agenda "" ((org-agenda-span 'day)
		      (org-agenda-overriding-header "\n======================\n")
                      (org-super-agenda-groups
                       '(
			 (:discard (:tag "hold"))
			 (:name "MITs" :tag "MIT" :order 0)
                         (:name "Schedule (C-c g to refresh google cal data, then g)" :time-grid t :order 1)
                         (:name "Upcoming deadlines" :deadline future :order 100)
                         (:name "Money" :tag "money" :order 3)
                         (:name "Guitarra (C-c a g)" :tag "guitar" :order 4)
                         (:name "Español (C-c a p)" :tag "spanish" :order 5)
                         (:name "Ejercicios (C-c a f)" :tag "fitness" :order 6)
                         (:name "Today (M-x org-revert-all-org-buffers to reload files)"
                                :date t
                                :scheduled today
                                :scheduled past
                                :deadline today
                                :deadline past
                                :order 2)
                         ))))
          (alltodo "" ((org-agenda-overriding-header "\n===================")
                       (org-super-agenda-groups
                        '(
                          (:name "Waiting" :todo "WAITING" :order 2)
                          (:name "Next actions" :todo "NEXT" :order 3)
                          ))))
	  )
         ((org-agenda-files '("~/Dropbox/org/inbox.org"
                         "~/Dropbox/org/inbox-remote.org"
                         "~/Dropbox/org/gtd.org"
                         "~/Dropbox/org/guitar.org"
                         "~/Dropbox/org/spanish.org"
                         "~/Dropbox/org/fitness.org"
                         "~/Dropbox/org/habits.org"
                         "~/Dropbox/org/tickler.org"
                         "~/Dropbox/org/schedule.org") ))

         )

	("h" tags "hold")

	("n" todo "NEXT")

	("i" "Inbox"
         ((alltodo "" ((org-agenda-overriding-header "Inbox"))))
         ((org-agenda-files '("~/Dropbox/org/inbox.org" "~/Dropbox/org/inbox-remote.org"))))

	,(my-common-agenda-command "g" "Guitar" "~/Dropbox/org/guitar.org")
	,(my-common-agenda-command "p" "Spanish" "~/Dropbox/org/spanish.org")
	,(my-common-agenda-command "f" "Fitness" "~/Dropbox/org/fitness.org")

        )
      )
;; eval the above: C-x C-e

;; (setq org-agenda-block-separator "--------\n")
(setq org-agenda-block-separator nil)
(setq org-agenda-compact-blocks nil)



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
                         "~/Dropbox/org/inbox-remote.org"
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

(setq org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 3)
                           ("~/Dropbox/org/guitar.org" :maxlevel . 3)
                           ("~/Dropbox/org/spanish.org" :maxlevel . 3)
                           ("~/Dropbox/org/fitness.org" :maxlevel . 3)
                           ("~/Dropbox/org/habits.org" :maxlevel . 3)
                           ("~/Dropbox/org/someday.org" :maxlevel . 3)
                           ("~/Dropbox/org/reference.org" :maxlevel . 3)
                           ("~/Dropbox/org/tickler.org" :maxlevel . 3)))

;; ref https://orgmode.org/manual/TODO-dependencies.html
;; if project has the following, open TODOs block subsequent ones:
;;   :PROPERTIES:
;;   :ORDERED:  t
;;   :END:
(setq org-enforce-todo-dependencies t)
(setq org-agenda-dim-blocked-tasks 'invisible)

(setq org-list-description-max-indent 5)
(setq org-ellipsis " ▼")
(setq org-tags-column 0)
(setq org-agenda-skip-scheduled-if-done t)

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


(setq org-confirm-babel-evaluate nil)
(setq org-confirm-shell-link-function nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   )
 )

;;;;;;;;;;;;;;;;;
;; Javascript
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; keybindings
(global-set-key "\C-ch" 'query-replace)
(global-set-key "\C-cr" 'query-replace-regexp)
(global-set-key "\C-cv" 'revert-buffer)
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
