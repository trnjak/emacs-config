(when (eq system-type 'darwin)
  (setq ns-pop-up-frames nil)
  (add-hook 'emacs-startup-hook
	    (lambda () (run-with-idle-timer 1 nil
					    (lambda () (setq ns-pop-up-frames t))))))

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
        gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(setq evil-want-keybinding nil)
(setq evil-want-integration t)
(unless (package-installed-p 'evil)
  (package-install 'evil))
(require 'evil)
(evil-mode 1)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(defun my/center-frame ()
  (let* ((f (selected-frame))
         (dw (display-pixel-width))
         (dh (display-pixel-height))
         (fw (frame-pixel-width f))
         (fh (frame-pixel-height f))
         (x (/ (- dw fw) 2))
         (y (/ (- dh fh) 2)))
    (set-frame-position f x y)))

(add-to-list 'initial-frame-alist '(width . 180))
(add-to-list 'initial-frame-alist '(height . 60))
(add-hook 'window-setup-hook #'my/center-frame)

(add-to-list 'custom-theme-load-path user-emacs-directory)
(load-theme 'Venturemacs-light t)

(require 'org)
(let ((org-file (expand-file-name "README.org" user-emacs-directory))
      (el-file (expand-file-name "README.el" user-emacs-directory)))
  (if (file-newer-than-file-p org-file el-file)
      (org-babel-load-file org-file)
    (load el-file)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
