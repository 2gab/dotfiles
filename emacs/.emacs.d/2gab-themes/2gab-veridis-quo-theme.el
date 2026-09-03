;;; 2gab-veridis-quo-theme.el --- Veridis Quo -*- lexical-binding:t -*-

;; Copyright (C) 2022-2026  Free Software Foundation, Inc.

;; Author: 2gab <2gabrielhdasilva@gmail.com>
;; Maintainer: 2gab <2gabrielhdasilva@gmail.com>
;; URL: https://github.com/2gab/2gab-themes
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))
;; Keywords: faces, theme, dark

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; `2gab-veridis-quo' is a warm dark theme for GNU Emacs inspired by
;; Daft Punk's "Veridis Quo" — ambient, introspective, and unhurried.
;;
;; The palette below was extracted directly from the "Veridis Quo"
;; official video (k-means clustering over ~100 sampled frames):
;; a near-black concert hall washed in cobalt stage light, robed
;; figures in violet and warm gold, pages of parchment-cream text,
;; and one hot orange spotlight cutting through it all.
;;
;; Deep near-black violet backgrounds, warm cream foregrounds, and
;; accents of gold, amber, sage, cobalt blue, violet, and rose — all
;; sampled from the film itself. Built entirely with Emacs' native
;; `deftheme' and `custom-theme-set-faces' facilities.

;;; Code:

(deftheme 2gab-veridis-quo
  "Warm dark theme inspired by Daft Punk — Veridis Quo.")

(let* ((class '((class color) (min-colors 89)))

       ;; ── Backgrounds — the concert hall, deepest at center ───────
       (bg-main    "#0F0C11")   ; void beyond the stage
       (bg-dim     "#1C1620")   ; elevated surfaces
       (bg-alt     "#2C2534")   ; panels, mode-line
       (bg-sel     "#3D3454")   ; selection — cobalt wash
       (bg-hl      "#17121B")   ; current line — subtle heat

       ;; ── Foreground — parchment lyrics under stage light ─────────
       (fg-main    "#D9CBBB")   ; warm cream — primary text
       (fg-dim     "#A3907C")   ; muted gold — secondary
       (fg-faint   "#675848")   ; distant — line numbers, ghosts

       ;; ── Accent palette — sampled from the film itself ───────────
       (gold       "#C99A2E")   ; robed-figure gold      → comments
       (amber      "#E8A93A")   ; bright amber flame      → strings
       (sage       "#9FBE84")   ; rare glimpse of green   → functions
       (teal       "#3D6BB0")   ; cobalt stage light      → types
       (orange     "#E2591A")   ; vivid surface orange    → constants
       (violet     "#8B7BAE")   ; purple cloak            → keywords
       (rose       "#C15A78")   ; warm rose                → builtins
       (sky        "#8CA3C7")   ; hazy cobalt haze        → variables
       (crimson    "#C4405A")   ; error / warning
       (cursor-c   "#FF7A2E"))  ; cursor — hot spotlight

  (custom-theme-set-faces
   '2gab-veridis-quo

   ;; ── Base UI ─────────────────────────────────────────────────────
   `(default                    ((,class (:background ,bg-main :foreground ,fg-main))))
   `(fringe                     ((,class (:background ,bg-main :foreground ,fg-faint))))
   `(vertical-border            ((,class (:foreground ,bg-alt))))
   `(border                     ((,class (:background ,bg-alt :foreground ,bg-alt))))
   `(internal-border            ((,class (:background ,bg-main))))
   `(cursor                     ((,class (:background ,cursor-c))))
   `(region                     ((,class (:background ,bg-sel :extend t))))
   `(highlight                  ((,class (:background ,bg-dim))))
   `(hl-line                    ((,class (:background ,bg-hl :extend t))))
   `(secondary-selection        ((,class (:background ,bg-alt))))
   `(trailing-whitespace        ((,class (:background ,crimson))))
   `(minibuffer-prompt          ((,class (:foreground ,gold :weight bold))))
   `(shadow                     ((,class (:foreground ,fg-faint))))
   `(escape-glyph               ((,class (:foreground ,amber))))
   `(homoglyph                  ((,class (:foreground ,amber))))

   ;; ── Line numbers ────────────────────────────────────────────────
   `(line-number                ((,class (:foreground ,fg-faint :background ,bg-main))))
   `(line-number-current-line   ((,class (:foreground ,amber :background ,bg-hl :weight bold))))
   `(line-number-major-tick     ((,class (:foreground ,fg-dim :background ,bg-main))))
   `(line-number-minor-tick     ((,class (:foreground ,fg-faint :background ,bg-main))))

   ;; ── Syntax ──────────────────────────────────────────────────────
   `(font-lock-keyword-face               ((,class (:foreground ,violet :weight bold))))
   `(font-lock-string-face                ((,class (:foreground ,amber))))
   `(font-lock-comment-face               ((,class (:foreground ,gold :slant italic))))
   `(font-lock-comment-delimiter-face     ((,class (:foreground ,fg-faint :slant italic))))
   `(font-lock-doc-face                   ((,class (:foreground ,gold))))
   `(font-lock-doc-markup-face            ((,class (:foreground ,fg-dim))))
   `(font-lock-function-name-face         ((,class (:foreground ,sage :weight bold))))
   `(font-lock-variable-name-face         ((,class (:foreground ,sky))))
   `(font-lock-variable-use-face          ((,class (:foreground ,sky))))
   `(font-lock-type-face                  ((,class (:foreground ,teal))))
   `(font-lock-constant-face              ((,class (:foreground ,orange :weight bold))))
   `(font-lock-builtin-face               ((,class (:foreground ,rose))))
   `(font-lock-preprocessor-face          ((,class (:foreground ,violet))))
   `(font-lock-negation-char-face         ((,class (:foreground ,crimson :weight bold))))
   `(font-lock-warning-face               ((,class (:foreground ,crimson :weight bold))))
   `(font-lock-number-face                ((,class (:foreground ,orange))))
   `(font-lock-operator-face              ((,class (:foreground ,rose))))
   `(font-lock-punctuation-face           ((,class (:foreground ,fg-dim))))
   `(font-lock-regexp-grouping-construct  ((,class (:foreground ,amber))))
   `(font-lock-regexp-grouping-backslash  ((,class (:foreground ,orange))))
   `(font-lock-escape-face                ((,class (:foreground ,amber :weight bold))))

   ;; ── Mode line ───────────────────────────────────────────────────
   `(mode-line              ((,class (:background ,bg-alt :foreground ,fg-main
                                      :box (:line-width 1 :color ,bg-sel)))))
   `(mode-line-inactive     ((,class (:background ,bg-dim :foreground ,fg-faint
                                      :box (:line-width 1 :color ,bg-dim)))))
   `(mode-line-buffer-id    ((,class (:foreground ,amber :weight bold))))
   `(mode-line-emphasis     ((,class (:foreground ,gold :weight bold))))
   `(mode-line-highlight    ((,class (:foreground ,sage))))

   ;; ── Links ───────────────────────────────────────────────────────
   `(link                   ((,class (:foreground ,sky :underline t))))
   `(link-visited           ((,class (:foreground ,violet :underline t))))
   `(button                 ((,class (:foreground ,sky :underline t))))

   ;; ── Search & match ──────────────────────────────────────────────
   `(isearch                ((,class (:background ,orange :foreground ,bg-main :weight bold))))
   `(isearch-fail           ((,class (:background ,crimson :foreground ,fg-main))))
   `(isearch-group-1        ((,class (:background ,amber :foreground ,bg-main))))
   `(isearch-group-2        ((,class (:background ,gold :foreground ,bg-main))))
   `(lazy-highlight         ((,class (:background ,bg-sel :foreground ,amber))))
   `(match                  ((,class (:background ,bg-sel :foreground ,gold :weight bold))))

   ;; ── Errors & diagnostics ────────────────────────────────────────
   `(error                  ((,class (:foreground ,crimson :weight bold))))
   `(warning                ((,class (:foreground ,orange :weight bold))))
   `(success                ((,class (:foreground ,sage :weight bold))))

   ;; ── Parentheses & delimiters ────────────────────────────────────
   `(show-paren-match               ((,class (:background ,bg-sel :foreground ,amber :weight bold))))
   `(show-paren-mismatch            ((,class (:background ,crimson :foreground ,fg-main :weight bold))))
   `(show-paren-match-expression    ((,class (:background ,bg-sel))))

   `(rainbow-delimiters-depth-1-face   ((,class (:foreground ,violet))))
   `(rainbow-delimiters-depth-2-face   ((,class (:foreground ,sage))))
   `(rainbow-delimiters-depth-3-face   ((,class (:foreground ,amber))))
   `(rainbow-delimiters-depth-4-face   ((,class (:foreground ,teal))))
   `(rainbow-delimiters-depth-5-face   ((,class (:foreground ,sky))))
   `(rainbow-delimiters-depth-6-face   ((,class (:foreground ,rose))))
   `(rainbow-delimiters-depth-7-face   ((,class (:foreground ,orange))))
   `(rainbow-delimiters-depth-8-face   ((,class (:foreground ,gold))))
   `(rainbow-delimiters-depth-9-face   ((,class (:foreground ,fg-dim))))
   `(rainbow-delimiters-unmatched-face ((,class (:foreground ,crimson :weight bold :underline t))))
   `(rainbow-delimiters-mismatched-face((,class (:foreground ,crimson :weight bold))))

   ;; ── Diff / VC ───────────────────────────────────────────────────
   `(diff-added             ((,class (:foreground ,sage :background "#1E2C17"))))
   `(diff-removed           ((,class (:foreground ,crimson :background "#2D161B"))))
   `(diff-changed           ((,class (:foreground ,amber :background "#2E2614"))))
   `(diff-header            ((,class (:foreground ,gold :background ,bg-alt))))
   `(diff-file-header       ((,class (:foreground ,fg-main :background ,bg-alt :weight bold))))
   `(diff-hunk-header       ((,class (:foreground ,violet :background ,bg-dim))))
   `(diff-context           ((,class (:foreground ,fg-dim))))
   `(diff-refine-added      ((,class (:foreground ,sage :background "#2B4021" :weight bold))))
   `(diff-refine-removed    ((,class (:foreground ,crimson :background "#411F28" :weight bold))))

   `(magit-diff-added              ((,class (:foreground ,sage :background "#1E2C17"))))
   `(magit-diff-removed            ((,class (:foreground ,crimson :background "#2D161B"))))
   `(magit-diff-added-highlight    ((,class (:foreground ,sage :background "#2B4021"))))
   `(magit-diff-removed-highlight  ((,class (:foreground ,crimson :background "#411F28"))))
   `(magit-section-heading         ((,class (:foreground ,amber :weight bold))))
   `(magit-section-highlight       ((,class (:background ,bg-dim))))
   `(magit-branch-local            ((,class (:foreground ,sage :weight bold))))
   `(magit-branch-remote           ((,class (:foreground ,teal :weight bold))))
   `(magit-hash                    ((,class (:foreground ,fg-faint))))
   `(magit-log-author              ((,class (:foreground ,rose))))
   `(magit-log-date                ((,class (:foreground ,gold))))

   ;; ── Org mode ────────────────────────────────────────────────────
   `(org-level-1            ((,class (:foreground ,amber :weight bold :height 1.2))))
   `(org-level-2            ((,class (:foreground ,sage :weight bold :height 1.1))))
   `(org-level-3            ((,class (:foreground ,sky :weight bold))))
   `(org-level-4            ((,class (:foreground ,teal))))
   `(org-level-5            ((,class (:foreground ,violet))))
   `(org-level-6            ((,class (:foreground ,gold))))
   `(org-level-7            ((,class (:foreground ,rose))))
   `(org-level-8            ((,class (:foreground ,orange))))
   `(org-code               ((,class (:foreground ,amber))))
   `(org-verbatim           ((,class (:foreground ,rose))))
   `(org-block              ((,class (:background ,bg-dim :extend t))))
   `(org-block-begin-line   ((,class (:foreground ,fg-faint :background ,bg-dim :extend t))))
   `(org-block-end-line     ((,class (:foreground ,fg-faint :background ,bg-dim :extend t))))
   `(org-quote              ((,class (:background ,bg-dim :slant italic :extend t))))
   `(org-todo               ((,class (:foreground ,orange :weight bold))))
   `(org-done               ((,class (:foreground ,sage :weight bold))))
   `(org-headline-done      ((,class (:foreground ,fg-faint))))
   `(org-date               ((,class (:foreground ,sky :underline t))))
   `(org-link               ((,class (:foreground ,sky :underline t))))
   `(org-tag                ((,class (:foreground ,fg-faint :weight bold))))
   `(org-table              ((,class (:foreground ,fg-dim))))
   `(org-formula            ((,class (:foreground ,rose))))
   `(org-document-title     ((,class (:foreground ,amber :weight bold :height 1.4))))
   `(org-document-info      ((,class (:foreground ,gold))))
   `(org-document-info-keyword ((,class (:foreground ,fg-faint))))

   ;; ── Completions ─────────────────────────────────────────────────
   `(completions-common-part       ((,class (:foreground ,amber :weight bold))))
   `(completions-first-difference  ((,class (:foreground ,fg-main))))
   `(completions-annotations       ((,class (:foreground ,fg-dim))))

   ;; ── Company / Corfu ─────────────────────────────────────────────
   `(company-tooltip                    ((,class (:background ,bg-alt :foreground ,fg-main))))
   `(company-tooltip-common             ((,class (:foreground ,amber :weight bold))))
   `(company-tooltip-selection          ((,class (:background ,bg-sel :foreground ,fg-main))))
   `(company-tooltip-annotation         ((,class (:foreground ,fg-dim))))
   `(company-scrollbar-bg               ((,class (:background ,bg-dim))))
   `(company-scrollbar-fg               ((,class (:background ,gold))))
   `(corfu-default                      ((,class (:background ,bg-alt :foreground ,fg-main))))
   `(corfu-current                      ((,class (:background ,bg-sel))))
   `(corfu-bar                          ((,class (:background ,gold))))
   `(corfu-border                       ((,class (:background ,bg-sel))))
   `(corfu-annotations                  ((,class (:foreground ,fg-dim))))

   ;; ── Whitespace & fill ───────────────────────────────────────────
   `(whitespace-space          ((,class (:foreground ,fg-faint))))
   `(whitespace-tab            ((,class (:foreground ,fg-faint :background ,bg-dim))))
   `(whitespace-newline        ((,class (:foreground ,fg-faint))))
   `(whitespace-trailing       ((,class (:background ,crimson))))
   `(whitespace-line           ((,class (:background ,bg-dim :foreground ,crimson))))
   `(fill-column-indicator     ((,class (:foreground ,bg-alt))))

   ;; ── Flycheck / Flymake ──────────────────────────────────────────
   `(flycheck-error             ((,class (:underline (:style wave :color ,crimson)))))
   `(flycheck-warning           ((,class (:underline (:style wave :color ,orange)))))
   `(flycheck-info              ((,class (:underline (:style wave :color ,sky)))))
   `(flymake-error              ((,class (:underline (:style wave :color ,crimson)))))
   `(flymake-warning            ((,class (:underline (:style wave :color ,orange)))))
   `(flymake-note               ((,class (:underline (:style wave :color ,sky)))))

   ;; ── Treemacs / Dired ────────────────────────────────────────────
   `(treemacs-directory-face    ((,class (:foreground ,sky))))
   `(treemacs-file-face         ((,class (:foreground ,fg-main))))
   `(treemacs-root-face         ((,class (:foreground ,amber :weight bold))))
   `(treemacs-git-modified-face ((,class (:foreground ,orange))))
   `(treemacs-git-added-face    ((,class (:foreground ,sage))))
   `(treemacs-git-conflict-face ((,class (:foreground ,crimson))))
   `(dired-directory            ((,class (:foreground ,sky :weight bold))))
   `(dired-symlink              ((,class (:foreground ,teal))))
   `(dired-special              ((,class (:foreground ,violet))))
   `(dired-flagged              ((,class (:foreground ,crimson :weight bold))))
   `(dired-marked               ((,class (:foreground ,amber :weight bold))))))

(provide-theme '2gab-veridis-quo)
;;; 2gab-veridis-quo-theme.el ends here
