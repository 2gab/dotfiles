;;; 2gab-math.el --- Math notebook: LaTeX preview in Org, Calc -*- lexical-binding: t; -*-

;;; Commentary:
;; org-fragtog auto-toggles LaTeX fragment previews as the cursor moves in
;; and out of them. Rendering needs a system LaTeX (pdflatex + dvisvgm):
;;   sudo pacman -S --needed texlive-basic texlive-binextra
;; Calc is built into Emacs; nothing to configure, `M-x calc' or `C-x * *'.

;;; Code:

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

(provide '2gab-math)
;;; 2gab-math.el ends here
