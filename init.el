(require 'package)

;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/"))

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))

(package-initialize)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq create-lockfiles nil)

(setq-default indent-tabs-mode nil)
;; http://stackoverflow.com/questions/27736107/emacs-started-adding-extra-tabs-in-when-i-paste-into-it-on-os-x
(setq-default electric-indent-mode nil)

(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
;;(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;;; For coverage warnings add this to your init.el
;;; (flycheck-add-next-checker 'javascript-flow 'javascript-flow-coverage)

(load-file "~/.emacs.d/rjsx-mode/rjsx-mode.el")
(load-file "~/.emacs.d/rjsx-mode/flow-js2-minor-mode.el")

(add-hook 'js2-mode-hook 'flow-minor-enable-automatically)

;; (load-file "~/.emacs.d/emacs-flow-jsx/emacs-flow-jsx-mode.el")
;; (load-file "~/.emacs.d/flow-mode/flow-mode.el")
;; (load-file "~/.emacs.d/rjsx-mode/flow-minor-mode.el")

;; doesnt work for terminal
;;(setq x-select-enable-clipboard t)
;;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(css-indent-offset 2)
 '(custom-enabled-themes (quote (wombat)))
 '(custom-safe-themes
   (quote
    ("b67840aabaec8198e91f7a96f955b70c75a9ff69b2da782cbc67feee90aeea16" default)))
 '(flycheck-javascript-flow-args nil)
 '(js-indent-level 2)
 '(js-switch-indent-offset 2)
 '(js2-strict-missing-semi-warning nil)
 '(json-reformat:indent-width 4)
 '(json-reformat:pretty-string\? t)
 '(mocha-reporter "spec")
 '(mocha-which-node "")
 '(package-selected-packages
   (quote
    (flow-minor-mode web-mode dumb-jump use-package yaml-mode yasnippet mocha json-mode auto-complete)))
 '(tab-width 4))

;; https://github.com/Fuco1/rjsx-mode.git

;; https://github.com/jacktasia/dumb-jump
;; inspired by IntelliJ's emacs bindings.
(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g k" . dumb-jump-back)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  :ensure)

;;; https://emacs.stackexchange.com/questions/33536/how-to-edit-jsx-react-files-in-emacs
(defadvice js-jsx-indent-line (after js-jsx-indent-line-after-hack activate)
  "Workaround sgml-mode and follow airbnb component style."
  (save-excursion
    (beginning-of-line)
    (if (looking-at-p "^ +\/?> *$")
        (delete-char sgml-basic-offset))))


;; ("melpa" . "http://melpa.milkbox.net/packages/")
;; auto-mode-alist is a built-in variable.
;; Its value is a list of pairs.
;; First element is a regex string. The second element is a mode name.
;; \\' or \\. - escapes slash with system symbol
;; setup files ending in “.js” to open in js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . flow-jsx-mode))
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("containers\\/.*\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))

(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
    (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;;Also you could setup any combination (for example M-TAB)
;;for invoking auto-complete:
;;(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

(global-set-key (kbd "M-RET") 'mocha-test-file)  ; Ctrl + Alt + M
(global-set-key (kbd "M--") 'other-window) ; switch window

;; (require 'auto-complete)
(global-auto-complete-mode t)
;; (require 'yasnippet)
(yas-global-mode 1)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(split-window-right)
