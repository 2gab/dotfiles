;;; 2gab-org.el --- Study & knowledge base: org-roam, org-noter, org-modern -*- lexical-binding: t; -*-

;;; Commentary:
;; The "connected knowledge base" layer from the config notes: org-roam for
;; a Zettelkasten, org-noter to tie notes to PDF pages (works with the
;; deferred pdf-tools from init.el), org-modern for a more readable Org
;; buffer. Kept small on purpose -- no capture template zoo, no extra
;; theming beyond org-modern's defaults.

;;; Code:

(defvar 2gab-org-roam-directory "~/org/roam/")

(unless (file-exists-p 2gab-org-roam-directory)
  (make-directory 2gab-org-roam-directory t))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename 2gab-org-roam-directory))
  ;; keep the sqlite db next to the notes, not inside the (git-tracked)
  ;; ~/.emacs.d
  (org-roam-db-location (expand-file-name "org-roam.db" 2gab-org-roam-directory))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n l" . org-roam-buffer-toggle))
  :config
  (org-roam-db-autosync-mode 1))

(use-package org-noter)

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)))

(provide '2gab-org)
;;; 2gab-org.el ends here
