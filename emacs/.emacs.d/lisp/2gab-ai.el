;;; 2gab-ai.el --- Claude Code agent integration -*- lexical-binding: t; -*-

;;; Commentary:
;; claude-code-ide.el bridges Claude Code (the CLI, already installed and
;; authenticated) into Emacs via MCP: project context, LSP/xref info,
;; diagnostics, buffer/selection tracking. It is not on MELPA, so it's
;; pulled straight from GitHub via `:vc' (native in Emacs 30+).
;;
;; Requires `vterm' (loaded by 2gab-terminal) as its terminal backend.
;; https://github.com/manzaltu/claude-code-ide.el

;;; Code:

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))

(provide '2gab-ai)
;;; 2gab-ai.el ends here
