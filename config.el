;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Get rid of all the horrible "smart" closing of things.
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; Place your private configuration here
(evil-set-undo-system 'undo-fu)

;; Make any files including Dockerfile use dockerfile mode.
(add-to-list 'auto-mode-alist '("\\Dockerfile\\'" . dockerfile-mode))

;; Swap ; and : for improving chances of not getting tendinitis.
(map! :nvem ":" #'evil-repeat-find-char)
(map! :nvem ";" #'evil-ex)

(after! evil
  (defalias #'forward-evil-word #'forward-evil-symbol))

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

;; Provide syntax highlighting for vivado xdc files used in FPGAs
;; Copyright (C) 2013 Jim Wu
;; Author: Jim Wu (jimwu88 at yahoo dot com)
(add-hook 'vivado-mode-hook '(lambda () (font-lock-mode 1)))
(autoload 'vivado-mode "vivado-mode")

(setq vivado_keywords
 '(("\\<\\(get_files\\|get_clocks\\|get_cells\\|get_pins\\|get_ports\\|get_nets\\)\\>" . font-lock-keyword-face)
   ("\\<\\(create_generated_clock\\|create_clock\\|set_input_jitter\\|set_input_delay\\|set_output_delay\\)\\>" . font-lock-keyword-face)
   ("\\<\\(set_property\\|set_clock_groups\\|set_multicycle_path\\|set_false_path\\|set_max_delay\\)\\>" . font-lock-keyword-face)
   ("\\<\\(create_pblock\\|add_cells_to_pblock\\|resize_pblock\\)\\>" . font-lock-keyword-face)
   ("\\<\\(CLOCK_DEDICATED_ROUTE\\|IOSTANDARD\\|DRIVE\\|DIFF_TERM\\|VCCAUX_IO\\|SLEW\\|FAST\\|DCI_CASCADE\\)\\>" . font-lock-constant-face)
   ("\\<\\(PACKAGE_PIN\\|IOB\\|LOC\\)\\>" . font-lock-constant-face)
   ("-\\<\\(name\\|period\\|clock\\|through\\|filter\\|hierarchical\\|hier\\|fall_from\\|rise_from\\|add_delay\\)\\>" . font-lock-constant-face)
   ("-\\<\\(max\\|min\\|rise_to\\|fall_to\\|of_objects\\|from\\|to\\|setup\\|hold\\|end\\|start\\|of\\|group\\)\\>" . font-lock-constant-face)
   ("-\\<\\(physically_exclusive\\|asynchronous\\|min\\|rise_to\\|fall_to\\|of_objects\\|from\\|to\\|setup\\|hold\\|of\\|group\\|asynchronous\\)\\>" . font-lock-constant-face)
   ("-\\<\\(include_generated_clocks\\|primitive_group\\|pppasynchronous\\)\\>" . font-lock-constant-face)

   ("\\<\\(create_bd_design\\|create_bd_cell\\|create_bd_intf_pin\\|current_bd_instance\\)\\>" . font-lock-keyword-face)
   ("\\<\\(create_bd_pin\\|connect_bd_intf_net\\|connect_bd_net\\|create_bd_addr_seg\\)\\>" . font-lock-keyword-face)
   ("-\\<\\(intf_net\\|dict\\|range\\|offset\\|dir\\|type\\|vlnv\\|net\\)\\>" . font-lock-constant-face)
  )
)
(define-derived-mode vivado-mode tcl-mode
  (setq font-lock-defaults '(vivado_keywords))
  (setq mode-name "vivado mode")
)
(provide 'vivado-mode)
;; End of snippet copyrighted by Jim Wu.
(add-to-list 'auto-mode-alist '("\\.xdc\\'" . vivado-mode))
