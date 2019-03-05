;;; package --- init.el

;; Author: Aleksandar Terentić

;;; Commentary:

;; Personal Emacs environment

;;; Code:

(setq user-full-name "Aleksandar Terentić")
(setq user-mail-address "aterentic@gmail.com")

(require 'package)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("melpa-stable" . "http://stable.melpa.org/packages/")
	("melpa" . "http://melpa.milkbox.net/packages/")
	("marmalade" . "http://marmalade-repo.org/packages/")
	("tromey" . "http://tromey.com/elpa/")))

(defvar package-list
  '(move-text uuidgen paredit helm auto-complete company yasnippet flycheck
	      csv-mode js2-mode js2-refactor web-mode json-mode dockerfile-mode
	      pocket-reader ac-js2 prettier-js markdown-mode org-tree-slide
	      clojure-mode elm-mode flycheck-elm cider sonic-pi tidal projectile
	      rainbow-delimiters tagedit magit haskell-mode idris-mode intero
	      go-mode go-rename go-autocomplete go-direx go-guru gotest godoctor
	      company-go yaml-mode powerline exec-path-from-shell color-theme-solarized
	      nyan-mode zone-nyan zone-sl zone-rainbow pdf-tools htmlize fireplace material-theme))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(org-babel-do-load-languages 'org-babel-load-languages '((emacs-lisp . nil) (shell . t)))
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(require 'org-agenda)
(add-to-list 'org-agenda-custom-commands
             '("k" "Kupovina" tags "kupovina/TODO"))

;;; helm
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

;;; enable subword-mode for all programming langs
(add-hook 'prog-mode-hook 'subword-mode)

;;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;; auto-complete
(ac-config-default)

(require 'company)

;;; flycheck
(global-flycheck-mode)

;;; magit
(global-set-key (kbd "C-x g") 'magit-status)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'intero-mode)

(require 'tidal)

;;; go-mode
(require 'go-mode)
(require 'go-autocomplete)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook (lambda ()
			  (local-set-key (kbd "C-c C-k") 'godoc)
			  (local-set-key (kbd "C-c C-b") 'pop-tag-mark)))
(add-hook 'go-mode-hook (lambda ()
			  (set (make-local-variable 'company-backends) '(company-go))
			  (company-mode)))

;;; elm-mode
(add-to-list 'company-backends 'company-elm)

(eval-after-load 'flycheck '(flycheck-elm-setup))

(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)

(require 'js2-refactor)
(add-hook 'js-mode-hook (lambda () (setq tab-width 4)))
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-m")
(setq js2-highlight-level 3)
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(require 'web-mode)
(add-hook 'web-mode-hook (lambda () (setq tab-width 4) (setq web-mode-code-indent-offset 2)))
(add-hook 'web-mode-hook
      (lambda ()
        (if (equal web-mode-content-type "javascript")
            (web-mode-set-content-type "jsx")
          (message "now set to: %s" web-mode-content-type))))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
(flycheck-add-mode 'javascript-eslint 'web-mode)

(move-text-default-bindings)

(require 'zone)
(zone-when-idle 180)
(setq zone-programs
      (vconcat zone-programs [zone-nyan zone-sl zone-rainbow]))

;;; powerline
(require 'powerline)
(require 'nyan-mode)
(powerline-default-theme)
(nyan-mode 1)
(nyan-toggle-wavy-trail)
(nyan-start-animation)

;;; themes
(load-theme 'material t)

(setq inhibit-splash-screen t initial-scratch-message nil)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-x C-;") 'comment-or-uncomment-region)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-hl-line-mode)
(display-time-mode 1)
(desktop-save-mode 1)
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
(setq grep-find-ignored-directories '(".git" "vendor" "node_modules"))

(if (file-exists-p "~/.emacs.d/default.el") (load-file "~/.emacs.d/default.el"))

(toggle-frame-fullscreen)
(server-mode)

;;; init.el ends here
