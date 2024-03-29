;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; asdfsync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Carsten Kragelund"
      user-mail-address "carsten@kragelund.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Rec Mono Nyx" :size 20 :weight 'Regular)
      doom-big-font (font-spec :family "Rec Mono Nyx" :size 36 :weight 'Regular)
      doom-variable-pitch-font (font-spec :family "Recursive" :style "Sans Casual" :weight 'Regular)
      doom-serif-font (font-spec :family "AreonPro" :weight 'Regular))
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(add-to-list 'custom-theme-load-path (concat (getenv "HOME") "/source/ctp-emacs"))
(load-theme 'catppuccin t t)
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!



;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! fixmee
  :after (button-lock nav-flash back-button smartrep string-utils tabulated-list)
  :config
  (setq fixmee-notice-regexp "\\(TODO+\\(?:\(\\w+\)\\)?:\\)"))

(use-package! hl-todo
  :config
  (setq hl-todo-keyword-faces (assoc-delete-all "TODO" hl-todo-keyword-faces))
  (add-to-list 'hl-todo-keyword-faces '("TODO+" . (warning bold))))

(use-package! org
  :config
  (setq org-src-fontify-natively t)
  (add-to-list 'org-src-block-faces (list "" (list :foreground (catppuccin-get-color 'green))))

  (defun ctp/text-org-blocks ()
    (face-remap-add-relative 'org-block (list :foreground (catppuccin-get-color 'text))))
  (add-hook! 'org-mode-hook 'ctp/text-org-blocks)

  (defun ctp/org-heading-colors ()
    (face-remap-add-relative 'org-level-1 (list :foreground (catppuccin-get-color 'blue)))
    (face-remap-add-relative 'org-level-2 (list :foreground (catppuccin-get-color 'red)))
    (face-remap-add-relative 'org-level-3 (list :foreground (catppuccin-get-color 'green)))
    (face-remap-add-relative 'org-level-4 (list :foreground (catppuccin-get-color 'lavender)))
    (face-remap-add-relative 'org-level-5 (list :foreground (catppuccin-get-color 'yellow)))
    (face-remap-add-relative 'org-level-6 (list :foreground (catppuccin-get-color 'maroon)))
    (face-remap-add-relative 'org-level-7 (list :foreground (catppuccin-get-color 'teal)))
    (face-remap-add-relative 'org-level-8 (list :foreground (catppuccin-get-color 'mauve))))
  (add-hook! 'org-mode-hook 'ctp/org-heading-colors))
