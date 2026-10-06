;;; 2gab-init.el --- My personal file -*- lexical-binding: t; -*-

;;; code:

;; keep native-comp warnings out of a popup buffer -- they're almost always
;; harmless "might not be defined at compile time" notes from optional
;; integrations, not real errors.
(setq native-comp-async-report-warnings-errors 'silent)

;; route Custom's auto-saved state (package-selected-packages, etc.) to its
;; own untracked file instead of letting it append to this one.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;;; Loads
;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/2gab-themes/")
(load-theme '2gab-veridis-quo t)

;; nas-keys
;(add-to-list 'load-path "~/.emacs.d/nas")
;(require 'nas)
;(nas-mode 1)
;(add-hook 'after-init-hook #'nas-mode)

;; sidesplash
(let ((sidesplash-dir (expand-file-name "~/work/me/sidesplash/")))
  (if (file-directory-p sidesplash-dir)
      (progn
        (add-to-list 'load-path sidesplash-dir)
        (require 'sidesplash)
        (setq sidesplash-side 'left)
        (sidesplash-mode 1))
    (message "2gab-init: sidesplash not found at %s, skipping" sidesplash-dir)))

;; scratchgirl
(let ((scratchgirl-dir (expand-file-name "~/work/me/scratchgirl/")))
  (if (file-directory-p scratchgirl-dir)
      (progn
        (add-to-list 'load-path scratchgirl-dir)
        (require 'scratchgirl)
        (scratchgirl-mode 1))
    (message "2gab-init: scratchgirl not found at %s, skipping" scratchgirl-dir)))

;; readlog
;; safe to enable before pdf-tools loads below: it only calls into
;; pdf-view at runtime, from pdf-view-mode-hook, by which point a .pdf
;; file has already triggered pdf-tools' own autoloads.
(let ((readlog-dir (expand-file-name "~/work/me/readlog/")))
  (if (file-directory-p readlog-dir)
      (progn
        (add-to-list 'load-path readlog-dir)
        (require 'readlog)
        (readlog-pdf-tools-mode 1))
    (message "2gab-init: readlog not found at %s, skipping" readlog-dir)))

;; packages
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(setq package-install-upgrade-built-in t)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; org is bundled with Emacs, but we want the latest version from GNU ELPA.
(use-package org)

;; pdf-tools: better than doc-view for reading PDFs in Emacs.
;; :defer t + :init (not :config) is required for pdf-loader-install to
;; actually defer: pdf-loader-install only postpones pdf-tools-install (and
;; the epdfinfo autobuild) if pdf-tools itself hasn't been loaded yet, and
;; :config would force that load immediately on every startup.
(use-package pdf-tools
  :defer t
  :init
  (pdf-loader-install t)
  ;; global-display-line-numbers-mode breaks horizontal navigation
  ;; (C-f, C-b, C-x <, C-x >) in pdf-view-mode -- see pdf-tools README,
  ;; "Known problems".
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1))))

;; markdown-mode: README/docs/specs, GFM for GitHub-flavored files.
;; Live preview needs an external converter -- pandoc-cli (Arch) / pandoc
;; (Debian), see install.sh.
(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "pandoc"))

;; xclip: hooks kill-ring (C-w, M-w, C-k...) into the X11 clipboard via
;; interprogram-cut-function/-paste-function, so Emacs -nw shares the
;; clipboard with Firefox et al. GUI Emacs already does this natively.
(use-package xclip
  :unless (display-graphic-p)
  :config
  (xclip-mode 1))

;; modules
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require '2gab-completion)
(require '2gab-programming)
(require '2gab-git)
(require '2gab-terminal)
(require '2gab-ai)
(require '2gab-org)
(require '2gab-math)

;;; Customization
;; backups
(defvar my-backup-directory "~/.emacs.d/backups/")

(unless (file-exists-p my-backup-directory)
  (make-directory my-backup-directory t))

;; frame
(setq default-frame-alist
      '((top . 200)
	(left . 160)
	(width . 90)
	(height . 40)))

;; tabs
;; tab-line

;; tab-mode
;;(setq tab-bar-tab-hints t)
;;(setq tab-bar-position 'bottom)


;; terminal
;; term
;; eshell
;; ishell

;; fonts
;; https://github.com/be5invis/Iosevka/blob/v33.1.0/doc/PACKAGE-LIST.md
;; iosevka default -- guarded so a missing font doesn't abort the rest of init.el
(if (member "Iosevka" (font-family-list))
    (progn
      (set-face-attribute 'default nil :font "Iosevka-14")
      (set-face-attribute 'font-lock-keyword-face nil :font "Iosevka Bold")
      (set-face-attribute 'font-lock-variable-name-face nil :font "Iosevka SemiBold")
      (set-face-attribute 'font-lock-string-face nil :font "Iosevka Italic")
      (set-face-attribute 'font-lock-comment-face nil :font "Iosevka Italic")
      (set-face-attribute 'font-lock-constant-face nil :font "Iosevka Bold Italic")
      (set-face-attribute 'font-lock-function-name-face nil :font "Iosevka Bold"))
  (message "2gab-init: Iosevka font not found, skipping font setup (install ttc-iosevka)"))

;;; Emacs Variables
;; face
(scroll-bar-mode -1)
(fringe-mode 0)
(menu-bar-mode 0)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)
(setq cursor-type 'box)
(global-display-line-numbers-mode t)
(global-hl-line-mode 1)
(setq use-dialog-box nil)
(tab-bar-mode 0)
(global-tab-line-mode 0)
(setq tab-bar-close-button-show nil)
(setq ring-bell-function 'ignore)

;; backups
(setq auto-save-default t)
(setq backup-directory-alist `(("." . ,my-backup-directory)))
(setq make-backup-files t)
(setq delete-old-versions nil)
(setq version-control t)
(setq create-lockfiles nil)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq backup-by-copying t)
(setq vc-make-backup-files t)

(require 'recentf)
(recentf-mode 1)

(global-auto-revert-mode 1)

(setq bookmark-save-flag 1)

;;; Emacs Functions
;;


;;; 2gab-init.el ends here
