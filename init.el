(defun leet/ensure-folder (folder)
  "Ensure that a FOLDER exists."
  (let ((dir (expand-file-name folder user-emacs-directory)))
    (unless (file-directory-p dir)
      (message (concat "Creating " dir " folder"))
      (make-directory dir))))

(defvar leet-emacs-dir (file-truename user-emacs-directory)
  "The path to this .emacs.d directory.")
(defvar leet-local-dir (concat leet-emacs-dir ".local/"))
(defvar leet-var-dir (concat leet-local-dir "var/"))

(leet/ensure-folder leet-local-dir)
(leet/ensure-folder leet-var-dir)


;; General settings
(setq ring-bell-function 'ignore
      ; use version control
      version-control t
      ; don't ask for confirmation when opening symlinked file
      vc-follow-symlinks t
      ; History & backup settings (save nothing, that's what git is for
      auto-save-list-file-prefix nil
      auto-save-default nil
      create-lockfiles nil
      history-length 500
      make-backup-files nil
      load-prefer-newer t)

(setq-default indent-tabs-mode nil
	      tab-width 2)

(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; Set custom.el location
(setq custom-file (concat leet-var-dir "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file t t))


;; Recentf
(setq recentf-max-menu-items 0
      recentf-max-saved-items 300
      recentf-filename-handlers '(abbreviate-file-name)
      recentf-save-file (expand-file-name "recentf" leet-var-dir))
(recentf-mode)


;; Initialize package manager
(setq package-enable-at-startup nil)
(setq-default straight-use-package-by-default t)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/master/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)


;; User Interface
(defalias 'yes-or-no-p 'y-or-n-p)

(setq visible-bell t
      ; Do not show anything at startup
      inhibit-startup-buffer-menu t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message "locutus"
      initial-buffer-choice t
      initial-scratch-message "")

(set-face-attribute 'default nil :font "Hack-13")
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)
(toggle-frame-maximized)
(global-display-line-numbers-mode)
(global-auto-revert-mode)
(global-prettify-symbols-mode)

(use-package dracula-theme
  :config
  (load-theme 'dracula))

(use-package which-key
  :config
  (which-key-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package ivy
  :bind (("C-s" . 'swiper)
         ("C-x C-r" . 'counsel-recentf))
  :config
  (ivy-mode 1))

(use-package doom-modeline
  :custom
  (doom-modeline-height 15)
  :config
  (doom-modeline-mode 1))


;; Projects
(use-package projectile
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (setq projectile-enable-caching (not noninteractive)
        projectile-require-project-root nil
        projectile-cache-file (expand-file-name "projectile.cache" leet-var-dir)
        projectile-known-projects-file (expand-file-name "projectile.projects" leet-var-dir))
  :config
  (add-to-list 'projectile-globally-ignored-directories '"node_modules")
  (add-to-list 'projectile-globally-ignored-directories leet-var-dir)
  (add-to-list 'projectile-globally-ignored-directories leet-local-dir)
  (add-to-list 'projectile-globally-ignored-directories (expand-file-name "straight" user-emacs-directory))
  (projectile-mode))

(use-package counsel-projectile
  :ensure projectile
  :config
  (add-hook 'projectile-mode-hook (counsel-projectile-mode)))

(use-package rg
  :config
  (add-hook 'rg-mode-hook 'wgrep-rg-setup))

(use-package neotree
  :config
  (setq projectile-switch-project-action 'neotree-projectile-action)
  (global-set-key (kbd "M-n") 'neotree-toggle))

(use-package magit)
