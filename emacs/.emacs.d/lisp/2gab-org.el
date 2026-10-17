;;; 2gab-org.el --- Study & knowledge base: org-roam, org-noter, org-modern -*- lexical-binding: t; -*-

;;; Commentary:
;; The "connected knowledge base" layer from the config notes: org-roam for
;; a Zettelkasten, org-noter to tie notes to PDF pages (works with the
;; deferred pdf-tools from init.el), org-modern for a more readable Org
;; buffer, org-anki to push flashcards straight out of Org headings. Kept
;; small on purpose -- no capture template zoo, no extra theming beyond
;; org-modern's defaults.

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

;; org-anki: push flashcards straight out of Org headings into Anki, via
;; the AnkiConnect add-on (https://ankiweb.net/shared/info/2055492159)
;; listening on localhost:8765 -- so Anki must be running for sync to work.
;;
;; Write a card as a heading with the question as its body and a "Back"
;; (or "Answer") subheading, tagged with where it goes in Anki:
;;
;;   * What is the OOM Killer?
;;   :PROPERTIES:
;;   :ANKI_NOTE_TYPE: Basic
;;   :ANKI_DECK: Linux
;;   :END:
;;   Kernel process that kills processes when memory is exhausted.
;;
;;   ** Back
;;   ...
;;
;; Then C-c n s on that heading to push/update it in Anki, or C-c n S to
;; sync every ANKI_NOTE_TYPE heading in the buffer. Re-syncing an edited
;; heading updates the existing card instead of duplicating it.
(use-package org-anki
  :after org
  :bind (:map org-mode-map
         ("C-c n s" . org-anki-sync-entry)
         ("C-c n S" . org-anki-sync-all)))

(provide '2gab-org)
;;; 2gab-org.el ends here
