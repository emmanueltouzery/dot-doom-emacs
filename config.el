;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      "0" #'winum-select-window-0-or-10
      "1" #'winum-select-window-1
      "2" #'winum-select-window-2
      "3" #'winum-select-window-3
      "4" #'winum-select-window-4
      "5" #'winum-select-window-5
      "6" #'winum-select-window-6
      "7" #'winum-select-window-7
      "8" #'winum-select-window-8
      "9" #'winum-select-window-9)
(map! :leader "a" #'evil-switch-to-windows-last-buffer)

(setq doom-localleader-key ",")

(setq org-agenda-files (list "~/Dropbox/org/todo.org"))

(setq org-link-abbrev-alist
      '(("redm"      . "https://redmine.lit-transit.com/issues/%s")))

;; https://github.com/ananthakumaran/tide/issues/357
;; actually have a very large completion case at work
(setq  tide-server-max-response-length 999999999)

;; we use eslint with typescript, not tslint.
;; https://github.com/ananthakumaran/tide/issues/308
;; https://github.com/hlissner/doom-emacs/issues/1530#issuecomment-507653761
(add-hook 'typescript-mode-local-vars-hook
          (lambda ()
            (flycheck-add-next-checker 'typescript-tide 'javascript-eslint 'append)))
(add-hook 'typescript-mode-local-vars-hook
          (lambda ()
            (flycheck-add-next-checker 'tsx-tide 'javascript-eslint 'append)))

;; https://fedoraproject.org/wiki/How_to_use_Emacs_for_XML_editing#Set_up_schemas
(eval-after-load 'rng-loc
  '(add-to-list 'rng-schema-locating-files "~/.doom.d/xml/schemas.xml"))

;; don't fold org-mode files when opening them
(setq org-startup-folded nil)

;; we want typescript-mode for TSX files, definitely not web-mode
;; https://github.com/hlissner/doom-emacs/issues/2252
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

;; make myself a hydra similar to spacemacs' git microstate
(defhydra hydra-magit ()
  "magit"
  ("p" git-gutter:previous-hunk "previous hunk")
  ("n" git-gutter:next-hunk "next hunk")
  ("d" git-gutter:popup-hunk "diff hunk")
  ("r" git-gutter:revert-hunk "revert hunk")
  ("s" git-gutter:stage-hunk "stage hunk"))

(map! :leader :desc "Git hydra" "g ." #'hydra-magit/body)
(map! :leader :desc "Cycle agenda files" "o a c" #'org-cycle-agenda-files)

(defun save-noreindent ()
  (interactive)
  (fundamental-mode) ;; disable all language-specific features including reindent
  (ws-butler-mode -1) ;; disable delete trailing whitespace, only for this buffer
  (save-buffer)
  (ws-butler-mode +1) ;; restore delete trailing whitespace, only for this buffer
  (normal-mode)
  )

(map! :leader :desc "Save without reindenting" "f w" #'save-noreindent)

;; don't autocreate workspaces pretty please.
(setq +workspaces-on-switch-project-behavior nil)

;; https://magit.vc/manual/magit/Diff-Options.html
;; don't reverse video in the diffs, super distracting
(after! magit
  (setq magit-diff-refine-hunk (quote nil)))

