;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Get rid of all the horrible "smart" closing of things.
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; Place your private configuration here
(evil-set-undo-system 'undo-fu)

;; Make any files including Dockerfile use dockerfile mode.
(add-to-list 'auto-mode-alist '("\\Dockerfile\\'" . dockerfile-mode))

;; Don't make poetry try to update on every command.
(setq poetry-tracking-strategy 'projectile)

;; Org stuff.
(after! org
  (setq org-log-done ;; We want to have a FINISHED timestamp for tasks.
        'time
        org-capture-templates ;; Set custom capture templates. Almost the same as the default ones.
        '(("t" "Personal todo" entry
        (file+headline +org-capture-todo-file "Inbox")
        "* [ ] %?\nCREATED: %U\n %i\n%a" :prepend t) ;; Added a created timestamp here.
        ("n" "Personal notes" entry
        (file+headline +org-capture-notes-file "Inbox")
        "* %u %?\n%i\n%a" :prepend t)
        ("j" "Journal" entry
        (file+olp+datetree +org-capture-journal-file)
        "* %U %?\n%i\n%a" :prepend t)

        ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
        ;; {todo,notes,changelog}.org file is found in a parent directory.
        ;; Uses the basename from `+org-capture-todo-file',
        ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
        ("p" "Templates for projects")
        ("pt" "Project-local todo" entry  ; {project-root}/todo.org
        (file+headline +org-capture-project-todo-file "Inbox")
        "* TODO %?\nC: %U\n%i\n%a" :prepend t)
        ("pn" "Project-local notes" entry  ; {project-root}/notes.org
        (file+headline +org-capture-project-notes-file "Inbox")
        "* %U %?\n%i\n%a" :prepend t)
        ("pc" "Project-local changelog" entry  ; {project-root}/changelog.org
        (file+headline +org-capture-project-changelog-file "Unreleased")
        "* %U %?\n%i\n%a" :prepend t)

        ;; Will use {org-directory}/{+org-capture-projects-file} and store
        ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
        ;; support `:parents' to specify what headings to put them under, e.g.
        ;; :parents ("Projects")
        ("o" "Centralized templates for projects")
        ("ot" "Project todo" entry
        (function +org-capture-central-project-todo-file)
        "* TODO %?\nC: %U\n %i\n %a"
        :heading "Tasks"
        :prepend nil)
        ("on" "Project notes" entry
        (function +org-capture-central-project-notes-file)
        "* %U %?\n %i\n %a"
        :heading "Notes"
        :prepend t)
        ("oc" "Project changelog" entry
        (function +org-capture-central-project-changelog-file)
        "* %U %?\n %i\n %a"
        :heading "Changelog"
        :prepend t))))
