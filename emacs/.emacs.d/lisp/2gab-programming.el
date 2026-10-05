;;; 2gab-programming.el --- LSP, autocomplete, snippets, project -*- lexical-binding: t; -*-

;;; Commentary:
;; eglot (built-in) + corfu + cape for completion, yasnippet for snippets,
;; project.el (built-in) for project navigation, plus the visual aids that
;; used to live directly in init.el (rainbow-delimiters, rainbow-mode,
;; highlight-indent-guides).

;;; Code:

;; treesit-auto: maps .ts/.tsx/.js (and others) to the built-in *-ts-mode
;; variants, auto-installing the tree-sitter grammar on first use. Without
;; this, those extensions fall back to fundamental-mode -- no major mode,
;; no font-lock, no highlighting regardless of theme.
(use-package treesit-auto
  :custom
  (treesit-auto-install t)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; eglot ships with Emacs 29+. Wired only into the modes with a language
;; server actually configured on this machine, not all of prog-mode, so it
;; never tries to start a server where none exists.
(use-package eglot
  :ensure nil
  :hook (((typescript-ts-mode tsx-ts-mode js-ts-mode js-mode)
          . eglot-ensure)
         ((rust-ts-mode rust-mode) . eglot-ensure)
         ((c-ts-mode c-mode c++-ts-mode c++-mode) . eglot-ensure)
         ((python-ts-mode python-mode) . eglot-ensure)))

(use-package corfu
  :init
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  :custom
  (corfu-auto t)
  (corfu-cycle t))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; project.el is built into Emacs, no install needed.
;; project-find-file / project-switch-project / project-search-regexp / project-compile

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode)

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character))

(provide '2gab-programming)
;;; 2gab-programming.el ends here
