;;; 2gab-completion.el --- Minibuffer & completion stack -*- lexical-binding: t; -*-

;;; Commentary:
;; vertico + orderless + marginalia + consult + which-key.
;; Replaces the old flx-based fuzzy matching in vertico.

;;; Code:

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)))

(use-package which-key
  :init
  (which-key-mode 1))

(provide '2gab-completion)
;;; 2gab-completion.el ends here
