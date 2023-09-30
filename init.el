(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doc-view-continuous t)
 '(org-adapt-indentation nil)
 '(org-agenda-span 'month)
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(org-modules
   '(ol-bbdb ol-bibtex ol-docview ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m))
 '(package-selected-packages
   '(org-tree-slide rbenv rvm htmlize yaml-mode typescript-mode org doom-themes treemacs-persp treemacs-magit treemacs-icons-dired treemacs-projectile use-package treemacs magit org-gcal org-journal org-super-agenda helm)))


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
(require 'org-attach-screenshot)

;; ;; ido, and adding the 'dot' lets you pick a directory.
;; (ido-mode)
;; (setq ido-show-dot-for-dired t)

(require 'use-package)

;; https://github.com/takaxp/org-tree-slide
;; start and stop with M-x org-tree-slide-mode,
;; fn-f9 and fn-f10 to move prev and next.
(require 'org-tree-slide)
(with-eval-after-load "org-tree-slide"
  (define-key org-tree-slide-mode-map (kbd "<f9>") 'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>") 'org-tree-slide-move-next-tree)
  )

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
          treemacs-width                         20)

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

(setq org-tag-alist '(("MIT" . ?m)))
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "CURRENT(c)" "WAITING(w)" "APPT(a)" "|" "DONE(d)" "CANCELLED(x)" "DEFERRED(f)")))
(setq org-log-repeat nil)
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

;; Adding "effort" to the start of agenda items.
;; https://emacs.stackexchange.com/questions/53272/
;;    show-effort-and-clock-time-in-agenda-view
(setq org-agenda-prefix-format
      '((agenda . "%-6e")
        (todo . " %i %-12:c %-6e")
        (tags . " %i %-12:c")
        (search . " %i %-12:c")))

;; Capture templates
;; ref https://www.reddit.com/r/emacs/comments/7zqc7b/share_your_org_capture_templates/
(setq
 org-capture-templates
 '(
   ("s" "Someday" entry (file "~/Dropbox/org/someday.org")
    "* %i%?")
   ("g" "Guitar")
   ("gn" "New practice thing" entry (file "~/Dropbox/org/inbox.org")
    (file "~/Dropbox/org/templates/guitar_new_practice_item.org"))
   ("gp" "Practice log" entry (file "~/Dropbox/org/inbox.org")
    (file "~/Dropbox/org/templates/guitar_practice_log.org"))
   ("l" "Language")
   ("lt" "Translation" entry (file "~/Dropbox/org/inbox.org")
    (file "~/Dropbox/org/templates/srs_review.org"))
   ("t" "TODO" entry (file "~/Dropbox/org/inbox.org")
    "* TODO %?")
   ("T" "Tickler" entry (file "~/Dropbox/org/tickler.org")
    "* %i%?")
   ("r" "Reviews")
   ("rd" "Daily" entry (file "~/Dropbox/org/daily_reviews.org")
    (file "~/Dropbox/org/templates/daily_review.org"))
   ("w" "Log Workout")
   ("wg" "General" entry (file+datetree+prompt "~/Dropbox/org/workout.org") "* %?")
   ("wh" "Hang" entry (file+datetree+prompt "~/Dropbox/org/workout.org") "* hanging: %?")
   ("wp" "Pushups" entry (file+datetree+prompt "~/Dropbox/org/workout.org") "* pushups: %?")
   ("ws" "Primal squat" entry (file+datetree+prompt "~/Dropbox/org/workout.org") "* primal squat: %?")
   )
 )
;; C-x e to evaluate the above

;; org-super-agenda
(require 'org-super-agenda)
(org-super-agenda-mode)


;; Common agenda layout for major areas (guitar, spanish, fitness)
(defun my-common-agenda-command (command description file)
  `(,command ,description
	     (

              (agenda "" ((org-agenda-span 'day)
			  ;; (org-agenda-overriding-header ,description)
                          (org-agenda-overriding-header "\n")
                      (org-super-agenda-groups
                       '(
                         (:auto-category t)
                         (:name "Today"
                                :date t
                                :scheduled today
                                :scheduled past
                                :deadline today
                                :deadline past
                                :order 1)
                         ))))

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
                          (:discard (:scheduled future))
                          (:name "MITs" :tag "MIT" :order 2)
                          (:name "Big rocks" :tag "bigrock"  :order 1)
                          )
			)
		       ))

	  (agenda "" ((org-agenda-span 'day)
		      (org-agenda-overriding-header "
======================

M-x org-revert-all-org-buffers to reload files
C-c a : f Fitness / g Guitar

")
                      (org-super-agenda-groups
                       '(
			 (:discard (:tag "hold"))
			 (:name "MITs" :tag "MIT" :order 0)
                         (:name "Schedule (C-c g to refresh google cal data, then g)" :time-grid t :order 1)
                         (:name "Upcoming deadlines" :deadline future :order 100)
                         (:name "Money" :tag "money" :order 3)
                         ;; (:name "Ejercicios (C-c a f)" :tag "fitness" :order 4)
                         ;; (:name "Guitarra (C-c a g)" :tag "guitar" :order 5)
                         ;; (:name "Español (C-c a p)" :tag "spanish" :order 6)
                         (:name "The rest"
                                :not (:tag "guitar")
                                :date t
                                :scheduled today
                                :scheduled past
                                :deadline today
                                :deadline past
                                :order 7)
                         ))))
          (alltodo "" ((org-agenda-overriding-header "\n===================")
                       (org-super-agenda-groups
                        '(
                          (:name "Waiting" :todo "WAITING" :order 2)
                          (:name "Next actions" :todo "NEXT" :order 3)
                          ))))
	  )
         ((org-agenda-files '("~/Dropbox/org/inbox.org"
                         "~/Dropbox/org/gtd.org"
                         ;; "~/Dropbox/org/guitar.org"
                         ;; "~/Dropbox/org/spanish.org"
                         ;; "~/Dropbox/org/fitness.org"
                         "~/Dropbox/org/habits.org"
                         "~/Dropbox/org/tickler.org"
                         "~/Dropbox/org/schedule.org") ))

         )

	("h" tags "hold")

	("n" todo "NEXT")

	("i" "Inbox"
         ((alltodo "" ((org-agenda-overriding-header "Inbox"))))
         ((org-agenda-files '("~/Dropbox/org/inbox.org"))))

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

;; mobile, per https://mobileorg.github.io/documentation/#using-dropbox
;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

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
                         "~/Dropbox/org/reference.org"
                         "~/Dropbox/org/someday.org"
                         "~/Dropbox/org/schedule.org"))

;; Allow top-level refiling.  This is trickier using Helm,
;; see https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html
(setq org-refile-targets '((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
(setq org-outline-path-complete-in-steps nil)  ; Refile in a single go
(setq org-refile-use-outline-path t)  ; Show full paths for refiling
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-use-outline-path 'file)


;; (setq org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 3)
;;                            ("~/Dropbox/org/guitar.org" :maxlevel . 3)
;;                            ("~/Dropbox/org/spanish.org" :maxlevel . 3)
;;                            ("~/Dropbox/org/fitness.org" :maxlevel . 3)
;;                            ("~/Dropbox/org/habits.org" :maxlevel . 3)
;;                            ("~/Dropbox/org/someday.org" :maxlevel . 3)
;;                            ("~/Dropbox/org/reference.org" :maxlevel . 3)
;;                            ("~/Dropbox/org/tickler.org" :maxlevel . 3)))

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
;; (require 'org-checklist) ;; macro failure on emacs 29


(setq org-confirm-babel-evaluate nil)
(setq org-confirm-shell-link-function nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   )
 )

;; ref https://stackoverflow.com/questions/57828900/bulk-reschedule-org-agenda-items-preserving-date
(setq org-agenda-bulk-custom-functions
      `((?D (lambda () (call-interactively 'org-agenda-date-later)))
        ,@org-agenda-bulk-custom-functions))


;; Clocking
;; ref https://emacs.stackexchange.com/questions/30280/how-to-conveniently-insert-a-clock-entry
(defun jz/insert-custom-clock-entry ()
  (interactive)
  (insert "CLOCK: ")
  ;; Inserts the current time by default.
  (let ((current-prefix-arg '(4))) (call-interactively 'org-time-stamp-inactive))
  (insert "--")
  ;; Inserts the current time by default.
  (let ((current-prefix-arg '(4))) (call-interactively 'org-time-stamp-inactive))
  (org-ctrl-c-ctrl-c))

(global-set-key (kbd "C-c k") 'jz/insert-custom-clock-entry)


;; report
(fset 'update-report
   (kmacro-lambda-form [?\C-x ?\C-f ?~ ?/ ?D ?r ?o ?p ?b ?o ?x ?/ ?o ?r ?g ?/ ?r ?e ?p ?o ?r ?t ?. ?o ?r ?g return (menu-bar) Org Show/Hide Show\ All ?\C-u ?\C-c ?\C-x ?\C-u] 0 "%d"))
(global-set-key "\C-ct" 'update-report)



;;;;;;;;;;;;;;;;;
;; Javascript
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;
;; Ruby -- figuring out the mess.
;; (require 'rvm)
;; (rvm-use-default) ;; use rvm's default ruby for the current Emacs session

(require 'rbenv)
(global-rbenv-mode)
(setq rbenv-installation-dir "/.rbenv")

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


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Reading sentence-by-sentence
;; from http://kitchingroup.cheme.cmu.edu/blog/2015/06/29/Getting-Emacs-to-read-to-me/
;; Note hydra is installed with treemacs.
;; Load the head of the hydra with C-x r h, then s-s-s to speak each sentence.

(defvar words-voice "Jorge" "Mac voice to use for speaking.")

(defun words-speak (&optional text)
  "Speak word at point or region. Mac only."
  (interactive)
  (unless text
    (setq text (if (use-region-p)
                   (buffer-substring
                    (region-beginning) (region-end))
                 (thing-at-point 'word))))
  ;; escape some special applescript chars
  (setq text (replace-regexp-in-string "\\\\" "\\\\\\\\" text))
  (setq text (replace-regexp-in-string "\"" "\\\\\"" text))
  (do-applescript
   (format
    "say \"%s\" using \"Jorge\""
    text
    words-voice)))

(defun mac-say-sentence (&optional arg)
  "Speak sentence at point. With ARG, go forward ARG sentences."
  (interactive "P")
  ;; arg can be (4), 4, "-", or -1. we handle these like this.
  (let ((newarg))
    (when arg
      (setq newarg (cond
                    ((listp arg)
                     (round (log (car arg) 4)))
                    ((and (stringp arg) (string= "-" arg))
                     ((< 0 arg) arg)
                     -1)
                    (t arg)))
      (forward-sentence newarg)
      (when (< 0 newarg) (forward-word)))
    (when (thing-at-point 'sentence)
      (words-speak (thing-at-point 'sentence)))))


(defhydra mac-speak (:color red)
  "word speak"
  ("s" (progn (mac-say-sentence) (forward-sentence)(forward-word)) "Next sentence")
  ("S" (mac-say-sentence -1) "Previous sentence")
  ("n" (my-org-capture-todo) "Make a note")
  )

;; (define-prefix-command 'mac-speak-keymap)
;; (define-key mac-speak-keymap (vector ?s) 'mac-say-sentence)
;; (define-key mac-speak-keymap (vector ?h) 'mac-speak/body)
;; (global-set-key (kbd "\C-xr") 'mac-speak-keymap)


;; line spacing?
;; from https://www.reddit.com/r/emacs/comments/3hag14/line_spacing/
(defun xah-toggle-line-spacing ()
  "Toggle line spacing between no extra space to extra half line height."
  (interactive)
  (if (eq line-spacing nil)
      (setq line-spacing 0.25)
    (setq line-spacing nil)   ; no extra heigh between lines
    )
  (redraw-frame (selected-frame)))


;; No tool bar.
;; http://kb.mit.edu/confluence/display/istcontrib/Disabling+the+Emacs+menubar%2C+toolbar%2C+or+scrollbar
(tool-bar-mode -1)

;; Default font size.  Height = 10 x pts, so 180 = 18 pt.
(set-face-attribute 'default nil :height 160)


;; STARTUP SCREENS
;; Open org agenda as first screen.
;; (setq initial-buffer-choice
;;       (lambda ()
;;         (org-agenda nil "z")
;;         (delete-other-windows)
;;         (get-buffer "*Org Agenda*")
;;         )
;;       )

(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")


;; Positioning
;; https://emacs.stackexchange.com/questions/2269/how-do-i-get-my-initial-frame-to-be-the-desired-size
(when window-system
  (set-frame-position (selected-frame) 10 0)
  (set-frame-size (selected-frame) 120 40))
