;;; 2gab-math.el --- Math notebook: LaTeX preview in Org, Calc -*- lexical-binding: t; -*-

;;; Commentary:
;; org-fragtog auto-toggles LaTeX fragment previews as the cursor moves in
;; and out of them. On Arch, `texlive-basic' only ships plain TeX -- the
;; latex/pdflatex *format files* (latex.fmt/pdflatex.fmt) that the `latex'
;; and `pdflatex' binaries need to actually run come from `texlive-latex'.
;; Without it, latex prints "I can't find the format file" and Org's async
;; preview reports "done." anyway, leaving the fragment un-rendered with no
;; visible error. `texlive-latexrecommended' adds amsmath/amssymb, needed
;; for e.g. the `matrix' snippet's \begin{bmatrix}. Install with:
;;   sudo pacman -S --needed texlive-latex texlive-latexrecommended
;; Calc is built into Emacs; nothing to configure, `M-x calc' or `C-x * *'.

;;; Code:

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

(provide '2gab-math)
;;; 2gab-math.el ends here
