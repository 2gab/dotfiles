;;; 2gab-init.el --- My personal file -*- lexical-binding: t; -*-

;;; code:

;;; Loads 
;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/2gab-themes/")
(load-theme '2gab-discovery t)

;; splash 
(add-to-list 'load-path "~/.emacs.d/esplash/")
(require 'esplash) 
(add-hook 'emacs-startup-hook 'esplash)

;; packages
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(org ; For outlining. It's bundled with Emacs, but I'm using the latest version. https://orgmode.org/
                      flx ; For fuzzy-completion in vertico. https://github.com/lewang/flx
                      rainbow-delimiters ; Highlight parentheses in rainbow colors. https://github.com/Fanael/rainbow-delimiters
		      magit ; A mode for committing to git repositories and viewing Git history. https://github.com/magit/magit
		      vertico ; Nicely show menu completions. https://github.com/minad/vertico
		      autothemer ; Useful for theme development. https://github.com/jasonm23/autothemer
		      copilot ; An Emacs plugin for GitHub Copilot. https://github.com/copilot-emacs/copilot.el
		      highlight-indent-guides ; An emacs plugin for guide identation. https://github.com/DarthFennec/highlight-indent-guides
		      rainbow-mode ; Colorize color names in buffers. https://elpa.gnu.org/packages/rainbow-mode.html
              pdf-tools ; For reading pdf in Emacs, better than doc-view. https://elpa.nongnu.org/nongnu/pdf-tools.html
					  ))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq papckage-install-upgrade-built-in t)

;;; Customization
;; backups
(defvar my-backup-directory "~/.emacs.d/backups/")

(unless (file-exists-p my-backup-directory)
  (make-directory my-backup-directory t))

;; dired

;; org

;; copilot

;; mode line

;; buffers

;; indent-guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)

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
;; iosevka default
(set-frame-font "Iosevka-14" nil t)
(set-face-attribute 'default nil :font "Iosevka-14")
(set-face-attribute 'font-lock-keyword-face nil :font "Iosevka Bold")
(set-face-attribute 'font-lock-variable-name-face nil :font "Iosevka SemiBold")
(set-face-attribute 'font-lock-string-face nil :font "Iosevka Italic")
(set-face-attribute 'font-lock-comment-face nil :font "Iosevka Italic")
(set-face-attribute 'font-lock-constant-face nil :font "Iosevka Bold Italic")
(set-face-attribute 'font-lock-function-name-face nil :font "Iosevka Bold")

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
(setq modus-themes-mixed-fonts t)
(setq modus-themes-bold-constructs t)
(setq modus-themes-italic-constructs t)
(setq visual-mode-line 1)

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

