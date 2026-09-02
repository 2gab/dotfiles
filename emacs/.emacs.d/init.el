;;; 2gab-init.el --- My personal file -*- lexical-binding: t; -*-

;;; code:

;; keep native-comp warnings out of a popup buffer -- they're almost always
;; harmless "might not be defined at compile time" notes from optional
;; integrations, not real errors.
(setq native-comp-async-report-warnings-errors 'silent)

;;; Loads
;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/2gab-themes/")
(load-theme '2gab-veridis-quo t)

;; nas-keys
;(add-to-list 'load-path "~/.emacs.d/nas")
;(require 'nas)
;(nas-mode 1)
;(add-hook 'after-init-hook #'nas-mode)

;; esplash
(add-to-list 'load-path "~/.emacs.d/esplash/")
(require 'esplash)

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
  (pdf-loader-install t))

;; modules
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require '2gab-completion)
(require '2gab-programming)
(require '2gab-git)
(require '2gab-terminal)
(require '2gab-ai)
(require '2gab-org)

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
(setq initial-scratch-message nil)
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
