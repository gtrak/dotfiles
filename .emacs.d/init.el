(setq confirm-kill-emacs 'y-or-n-p)

;; It's in alt position on the native keyboard, annoying
(setq mac-command-modifier 'meta)
(setq mac-control-modifier 'ctrl)
;; for real keyboards
(setq mac-option-modifier 'meta)

(setq create-lockfiles nil)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "sensible-browser")

(setq column-number-mode t)

;;; can't find a better way to do this yet
(setq exec-path
      (cons "/usr/local/bin"
            (split-string
             (or (getenv "PATH") "")
             ":")))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")


;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

;; set local recipes, el-get-sources should only accept PLIST element

(setq
 my:el-get-packages
 '(el-get
   request
   ansible
   better-defaults
   switch-window
   zencoding-mode
   avy
   direnv
   es-mode
   graphql
   treepy
   paredit
   cider
   ;; cider deps
   edn
   multiple-cursors
   hydra
   ;; end
   less-css-mode
   markdown-mode
   handlebars-mode
   ;; magit
   magit
   magit-popup
   transient
   ghub
   coffee-mode
   company-mode
   tuareg-mode
   anaconda-mode
   yasnippet
   pianobar
   color-theme
   aggressive-indent-mode
   ag
   projectile
   helm
   helm-ag
   helm-ls-git
   helm-projectile
   auto-highlight-symbol
   undo-tree
   rjsx-mode
   prettier-eslint
   wakatime-mode
   reason-mode
   org-trello
   ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cljr-favor-prefix-notation nil)
 '(el-get-sources
   '((:name cider :checkout "v0.18.0")
     (:name magit :checkout "v2.90.1")
     (:name direnv :description "emacs-direnv" :type github :pkgname "wbolster/emacs-direnv" :compile "\\.el$" :prepare
            (progn
              (autoload 'direnv "emacs-direnv" "emacs-direnv" t)))
     (:name prettier-eslint :description "Prettier-eslint" :type github :pkgname "gtrak/prettier-eslint-emacs" :compile "\\.el$" :prepare
            (progn
              (autoload 'prettier-eslint "prettier-eslint" "Run prettier-eslint mode" t)))
     (:name graphql :description "graphql" :type github :pkgname "vermiculus/graphql.el" :compile "\\.el$" :prepare
            (progn
              (autoload 'graphql "graphql" "Load graphql" t)))
     (:name treepy :description "treepy" :type github :pkgname "volrath/treepy.el" :compile "\\.el$" :prepare
            (progn
              (autoload 'treepy "treepy" "Load treepy" t)))
     (:name ansible :description "emacs-ansible" :type github :pkgname "k1LoW/emacs-ansible" :compile "\\.el$" :prepare
            (progn
              (autoload 'ansible "emacs-ansible" "Run ansible mode" t)))
     (:name better-defaults :description "better-defaults" :type github :pkgname "technomancy/better-defaults" :compile "\\.el$" :prepare
            (progn
              (autoload 'better-defaults "better defaults" "Run better defaults" t)))
     (:name reason-mode :description "reason-mode" :type github :pkgname "reasonml-editor/reason-mode" :compile "\\.el$" :prepare
            (progn
              (autoload 'reason-mode "reason mode" "Run reason mode" t)
              (add-to-list 'auto-mode-alist
                           '("\\.re\\'" . reason-mode))))
     ))

 '(package-selected-packages
   '(tracking ansible ansible-vault async queue inflections direnv better-defaults))
 '(safe-local-variable-values
   '((cider-refresh-after-fn . "integrant.repl/resume")
     (cider-refresh-before-fn . "integrant.repl/suspend"))))

;; elpas
;; (el-get-bundle elpa:inflections)
;; (el-get-bundle elpa:better-defaults)

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

(require 'better-defaults)

(setq pianobar-username (getenv "PIANOBAR_USER"))
(setq pianobar-password (getenv "PIANOBAR_PASSWORD"))
(setq pianobar-station "7")

;;; bindings

(setq ansible::vault-password-file
     "/home/gary/dev/arena/godzilla/scripts/ansible_vault_lpass.sh")

;; override projectile commands with helm-projectile ones
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(require 'helm-projectile)
(helm-projectile-on)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "C-\"") 'avy-goto-char-2)

;;; the logitech scrolling workaround
(global-set-key [mouse-3] nil)

; otherwise projectile is only loaded in certain modes
(global-set-key (kbd "C-c p p") 'helm-projectile-switch-project)
(global-set-key (kbd "C-c p p") 'helm-projectile-switch-project)
(global-set-key (kbd "C-c p s s") 'helm-projectile-ag)
(global-set-key (kbd "C-c p v") 'projectile-vc)
(global-set-key (kbd "C-c p f") 'helm-projectile-find-file)

(require 'color-theme)
;; (color-theme-lawrence)
(color-theme-emacs-nw)

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defvar my-font)

(defun set-my-font (font)
  (setq my-font font)
  (setq mac-allow-anti-aliasing t)
  (set-frame-font my-font)
  (add-to-list 'default-frame-alist `(font . ,my-font)))

(defun font-input ()
  (interactive)
  (set-my-font "-*-Input Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))

(defun font-terminus ()
  ;;(setq my-font "-*-Terminus (TTF)-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
  (interactive)
  (set-my-font "-xos4-Terminus-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1"))

(defun font-andale ()
  (interactive)
  (set-my-font "-*-Andale Mono-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1"))

(defun font-monaco ()
  (interactive)
  (set-my-font "-*-Monaco-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))

;; (font-andale)
;; (font-monaco)
;; (font-terminus)
(font-input)

(require 'thingatpt)
(defun custom-capf ()
  "Complete the symbol at point."
  (let ((sap (symbol-at-point)))
    (when (and sap)
      (let ((bounds (bounds-of-thing-at-point 'symbol)))
        (list (car bounds) (cdr bounds)
              (dabbrev-get-candidates (symbol-name sap) t))))))

;; http://emacswiki.org/emacs/anything-dabbrev-expand.el
(require 'dabbrev)
(defun dabbrev-get-candidates (abbrev &optional all)
  (let ((dabbrev-check-other-buffers t))
    (dabbrev--reset-global-variables)
    (dabbrev--find-all-expansions abbrev nil)))

;; (defvar lispy-js-map)
;; (setq lispy-js-map
;;       (let ((map (make-sparse-keymap)))
;;         (define-key map (kbd "{") 'paredit-open-curly)
;;         (define-key map (kbd "(") 'paredit-open-round)
;;         (define-key map (kbd "[") 'paredit-open-square)
;;         (define-key map (kbd "}") 'paredit-close-curly)
;;         (define-key map (kbd ")") 'paredit-close-round)
;;         (define-key map (kbd "]") 'paredit-close-square)
;;         (define-key map (kbd "<C-tab>") 'company-complete)
;;         (define-key map (kbd "<M-SPC>") 'company-complete)
;;         (define-key map (kbd "M-u") 'upcase-word-at-point)
;;         (define-key map (kbd "M-l") 'downcase-word-at-point)
;;         (define-key map (kbd "C-c -") 'camelscore-word-at-point)
;;         (define-key map (kbd "M-;") 'comment-dwim)
;;         map))

;; (define-minor-mode lispy-js-mode
;;   "Bindings for a presentation using coffeescript"
;;   ;; The initial value.
;;   :init-value nil
;;   ;; The indicator for the mode line.
;;   :lighter " lispy-js"
;;   ;; The minor mode bindings.
;;   :keymap lispy-js-map
;;   :group 'gary)

;;; programming

(add-hook 'prog-mode-hook 'whitespace-mode)
;; (add-hook 'prog-mode-hook 'idle-highlight-mode)
(add-hook 'prog-mode-hook 'hl-line-mode)

(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'eldoc-mode)

(add-hook 'cider-repl-mode-hook 'eldoc-mode)

(setq cider-prompt-for-symbol nil)
(setq cider-repl-display-help-banner nil)
(setq cider-font-lock-dynamically nil)

(defun my-paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

(require 'yasnippet)
(yas-reload-all)

;; (add-hook 'js-mode-hook
;;            (lambda ()
;;              (push '("function" . ?ƒ) prettify-symbols-alist)
;;              (prettify-symbols-mode)
;;              (set (make-local-variable 'company-backends) '(company-capf))
;;              (set (make-local-variable 'completion-at-point-functions) '(custom-capf))
;;              (set (make-local-variable 'completion-styles) '(substring))
;;              (setq completion-category-overrides '((buffer (styles substring))))
;;              (set (make-local-variable 'company-dabbrev-downcase) nil)
;;              (company-mode)
;;              (yas-minor-mode)
;;              ;; earlier minor mode maps win
;;              (lispy-js-mode)
;;              (projectile-mode)
;;              (my-paredit-nonlisp)
;;              (prettify-symbols-mode 0)
;;              (js-jsx-mode)
;;              ))


(add-to-list 'auto-mode-alist '("\\.js.*" . rjsx-mode))
(add-hook 'rjsx-mode-hook
          (lambda () (add-hook 'after-save-hook 'prettier-eslint nil t)))



;; (require 'js2-mode)

;; (define-key js2-mode-map (kbd "M-,") 'pop-tag-mark)

(setq whitespace-style '(face trailing lines-tail tabs))

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
;; (add-hook 'emacs-lisp-mode-hook 'elisp-slime-nav-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)

(define-key emacs-lisp-mode-map (kbd "C-c v") 'eval-buffer)

(define-key read-expression-map (kbd "TAB") 'lisp-complete-symbol)
(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)

(global-set-key (kbd "M-x") 'helm-M-x)
; open helm buffer inside current window, not occupy whole other window
(setq helm-split-window-in-side-p t)


;;; Org-mode
(global-set-key (kbd "C-c l") 'org-store-link)
(setq org-return-follows-link 't)

(setq org-agenda-files (list "~/Dropbox/Docs/org/meta.org"
                             "~/Dropbox/Docs/org/home.org"
                             "~/Dropbox/Docs/org/work.org"
                             "~/Dropbox/Docs/org/biederman.org"
                             "~/Dropbox/Docs/org/hibler.org"
                             "/tmp/gcal1.org"
                             "/tmp/gcal2.org"))

(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-coc" 'org-capture)
(setq org-capture-templates '(("m" "Todo [meta]" entry
                               (file+headline "~/Dropbox/Docs/org/meta.org" "Next")
                               "* TODO %i%?")
                              ("h" "Todo [home]" entry
                               (file+headline "~/Dropbox/Docs/org/home.org" "Next")
                               "* TODO %i%?")
                              ("w" "Todo [work]" entry
                               (file+headline "~/Dropbox/Docs/org/work.org" "Next")
                               "* TODO %i%?")
                              ("s" "Todo [side]" entry
                               (file+headline "~/Dropbox/Docs/org/side.org" "Next")
                               "* TODO %i%?")
                              ("p" "Todo [personal]" entry
                               (file+headline "~/Dropbox/Docs/org/personal.org" "Next")
                               "* TODO %i%?")
                              ))
(setq org-log-done t)
(custom-set-variables '(org-trello-files '("~/Dropbox/Docs/org/home.org")))
(require 'org-trello)
(setq org-todo-keywords
      '((sequence "TODO" "DOING" "BLOCKED" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . org-warning)
        ("DOING" . "orange")
        ("BLOCKED" . (:foreground "blue" :weight bold))))

(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))

(global-set-key [f11] 'toggle-fullscreen)

;; Annoyingly minimizes the frame
(global-unset-key (kbd "C-z"))

(global-set-key (kbd "C-<tab>") 'completion-at-point)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; y instead of yes
(defalias 'yes-or-no-p 'y-or-n-p)

(defun coffee-custom ()
  "coffee-mode-hook"
  (setq coffee-tab-width 2)
  (local-set-key (kbd "TAB") 'coffee-indent-shift-right)
  (local-set-key (kbd "S-TAB") 'coffee-indent-shift-left))

(add-hook 'coffee-mode-hook 'coffee-custom 'projectile-mode)
(add-to-list 'auto-mode-alist '("\\.cjsx\\'" . coffee-mode))

;; File watchers tend to choke on emacs tmp files


(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; (setq js-indent-level 2)

(setq magit-last-seen-setup-instructions "1.4.0")
(setq git-commit-finish-query-functions nil)

(put 'erase-buffer 'disabled nil)

(define-globalized-minor-mode
  global-text-scale-mode
  text-scale-mode
  (lambda () (text-scale-mode 1)))

(defun global-text-scale-adjust (inc)
  (interactive)
  (text-scale-set 1)
  (kill-local-variable 'text-scale-mode-amount)
  (setq-default text-scale-mode-amount
                (if inc
                    (+ text-scale-mode-amount inc)
                  0))
  (global-text-scale-mode 1))

(defun everything-bigger ()
  (interactive)
  (global-text-scale-adjust 1))

(defun everything-smaller ()
  (interactive)
  (global-text-scale-adjust -1))

(defun everything-normal ()
  (interactive)
  (global-text-scale-adjust nil))

(global-set-key (kbd "M-0")
                'everything-normal)
(global-set-key (kbd "M-+")
                'everything-bigger)
(global-set-key (kbd "M-=")
                'everything-bigger)
(global-set-key (kbd "M--")
                'everything-smaller)


(defun source (filename)
  "Update environment variables from a shell source file."
  (interactive "fSource file: ")

  (message "Sourcing environment from `%s'..." filename)
  (with-temp-buffer

    (shell-command (format "diff -u <(true; export) <(source %s; export)" filename) '(4))

    (let ((envvar-re "declare -x \\([^=]+\\)=\\(.*\\)$"))
      ;; Remove environment variables
      (while (search-forward-regexp (concat "^-" envvar-re) nil t)
        (let ((var (match-string 1)))
          (message "%s" (prin1-to-string `(setenv ,var nil)))
          (setenv var nil)))

      ;; Update environment variables
      (goto-char (point-min))
      (while (search-forward-regexp (concat "^+" envvar-re) nil t)
        (let ((var (match-string 1))
              (value (read (match-string 2))))
          (message "%s" (prin1-to-string `(setenv ,var ,value)))
          (setenv var value)))))
  (message "Sourcing environment from `%s'... done." filename))

(source "~/.credentials")

(custom-set-variables `(wakatime-api-key ,(getenv "WAKATIME_KEY")))

;; (source "~/.genisys-staging")
(setq sql-postgres-login-params
      `((user :default ,(or (getenv "PGUSER") "gary"))
        (password :default ,(or (getenv "PGPASSWORD") ""))
        (database :default ,(or (getenv "PGDATABASE") "model_view"))
        (server :default ,(or (getenv "PGHOST") "localhost"))
        (port :default 5432)))



(defun sql-switch-sqli-buffer ()
  (interactive)
  (unless (and sql-buffer (buffer-live-p (get-buffer sql-buffer))
               (get-buffer-process sql-buffer))
    (sql-set-sqli-buffer))
  (setq last-sql-buffer (current-buffer))
  (pop-to-buffer sql-buffer))

(defun sqli-switch-sql-buffer ()
  (interactive)
  (pop-to-buffer last-sql-buffer))

(defun sql-clear-sqli-buffer ()
  (interactive)
  (unless (and sql-buffer (buffer-live-p (get-buffer sql-buffer))
               (get-buffer-process sql-buffer))
    (sql-set-sqli-buffer))
  (with-current-buffer sql-buffer
    (comint-clear-buffer)))


(require 'sql)
(define-key sql-mode-map (kbd "C-c C-z") 'sql-switch-sqli-buffer)
(define-key sql-mode-map (kbd "C-<tab>") 'dabbrev-completion)
(define-key sql-interactive-mode-map (kbd "C-<tab>") 'dabbrev-completion)
(define-key sql-mode-map (kbd "C-c M-o") 'sql-clear-sqli-buffer)
(define-key sql-interactive-mode-map (kbd "C-c C-z") 'sqli-switch-sql-buffer)

;; (sql-switch-sqli-buffer)

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

(global-set-key (kbd "C-S-<left>") (lambda ()
                                     (interactive)
                                     (shrink-window-horizontally 8)))
(global-set-key (kbd "C-S-<right>") (lambda ()
                                      (interactive)
                                      (enlarge-window-horizontally 8)))
(global-set-key (kbd "C-S-<down>") (lambda ()
                                     (interactive)
                                     (shrink-window 4)))


(global-set-key (kbd "C-S-<up>") (lambda ()
                                   (interactive)
                                   (enlarge-window 4)))

(global-set-key (kbd "C-S-j") (lambda ()
                                (interactive)
                                (shrink-window-horizontally 8)))
(global-set-key (kbd "C-:") (lambda ()
                              (interactive)
                              (enlarge-window-horizontally 8)))
(global-set-key (kbd "C-S-k") (lambda ()
                                (interactive)
                                (shrink-window 4)))
(global-set-key (kbd "C-S-l") (lambda ()
                                (interactive)
                                (enlarge-window 4)))



;; ;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ;; ## end of OPAM user-setup addition for emacs / base ## keep this line

(require 'merlin)
(require 'merlin-cap)

(autoload 'merlin-mode "merlin" nil t nil)
(add-hook 'tuareg-mode-hook 'merlin-mode t)
(add-hook 'caml-mode-hook 'merlin-mode t)

;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.

(define-key merlin-mode-map (kbd "M-,") 'merlin-pop-stack)
;; (add-hook 'projectile-after-switch-project-hook 'direnv-update-environment)

(define-key merlin-mode-map (kbd "M-.") 'merlin-locate)


(defun merlin-switch ()
  (interactive)
  (let* ((cur buffer-file-name)
         (file (cond
                ((string-suffix-p ".mli" cur) (substring cur 0 (- (length cur) 1)))
                ((string-suffix-p ".ml" cur) (concat cur "i"))
                (t (error (concat "Not an ocaml source file: " cur))))))
    (if (file-exists-p file)
        (merlin--goto-file-and-point (list (cons 'file file)))
      (error (concat "File does not exist: " file)))))

(define-key merlin-mode-map (kbd "C-c m") 'merlin-switch)

;;; opens up an interface when present
(setq merlin-locate-preference 'ml)
(setq merlin-debug t)
(setq merlin-locate-in-new-window 'never)

;;; better-defaults assumes we want helm, but it's a little annoying for the quick file open 
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(require 'cider)
(define-key cider-repl-mode-map (kbd "C-c M-o") 'cider-repl-clear-buffer)
(define-key clojure-mode-map (kbd "C-:") nil)

(add-hook 'tuareg-mode-hook 'auto-highlight-symbol-mode)

(require 'auto-highlight-symbol)
(define-key auto-highlight-symbol-mode-map (kbd "M--") 'everything-smaller)
(setq ahs-idle-interval 0.4)
;(ahs-restart-timer)

;;; pinging ..be (The Kingdom of Belgium)
(setq ffap-machine-p-known 'reject)

(require 'tuareg)

(setq tuareg-test-command  "bin/inline_tests_genisys.opt inline-test-runner genisys -only-test ")
(setq tuareg-project-dir "~/dev/arena/godzilla")

(defun tuareg-test-file ()
  (interactive)
  (with-output-to-temp-buffer "*tuareg-tests*"
    (let ((default-directory tuareg-project-dir)
          (cmd (concat tuareg-test-command
                       (file-name-nondirectory buffer-file-name))))
      (shell-command cmd "*tuareg-tests*" "*tuareg-tests*")
      (pop-to-buffer "*tuareg-tests*"))))

(define-key tuareg-mode-map (kbd "C-c t f") 'tuareg-test-file)

(defun tuareg-test-line ()
  (interactive)
  (with-output-to-temp-buffer "*tuareg-tests*"
    (let ((default-directory tuareg-project-dir)
          (cmd (concat tuareg-test-command
                       (file-name-nondirectory buffer-file-name)
                       ":"
                       (number-to-string (line-number-at-pos)))))
      (shell-command cmd "*tuareg-tests*" "*tuareg-tests*")
      (pop-to-buffer "*tuareg-tests*"))))

(define-key tuareg-mode-map (kbd "C-c t l") 'tuareg-test-line)

;; (defun sql-add-newline-first (output)
;;    "Add newline to beginning of OUTPUT for `comint-preoutput-filter-functions'"
;;   (concat "\n" output))


;; (defun sqli-add-hooks ()
;;   "Add hooks to `sql-interactive-mode-hook'."
;;   (add-hook 'comint-preoutput-filter-functions
;;             'sql-add-newline-first))

;; (add-hook 'sql-interactive-mode-hook 'sqli-add-hooks)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-mode)
(define-key anaconda-mode-map (kbd "M-,") 'anaconda-mode-go-back)

(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(global-undo-tree-mode)

(defun xdg-open ()
  "Use xdg-open shell command on X."
  (interactive)
  (call-process shell-file-name nil
                nil nil
                shell-command-switch
                (format "nohup %s %s &"
                        (if (eq system-type 'darwin)
                            "open"
                          "xdg-open")
                        (buffer-file-name))))

(set-fill-column 80)



(defun my-sql-login-hook ()
  "Custom SQL log-in behaviours. See `sql-login-hook'."
  ;; n.b. If you are looking for a response and need to parse the
  ;; response, use `sql-redirect-value' instead of `comint-send-string'.
  (when (eq sql-product 'postgres)
    (setq sql-prompt-regexp "^[[:alpha:]_]*=[#>] ")
    (setq sql-prompt-cont-regexp "^[[:alpha:]_]*[-(][#>] ")
    ;; (let ((proc (get-buffer-process (current-buffer))))
    ;;   ;; Output each query before executing it. (n.b. this also avoids
    ;;   ;; the psql prompt breaking the alignment of query results.)
    ;;   (comint-send-string proc "\\set ECHO queries\n")
    ;; )
    ))

(add-hook 'sql-login-hook 'my-sql-login-hook)


(global-wakatime-mode)


;;; reason stuff
;;----------------------------------------------------------------------------
;; Reason setup
;;----------------------------------------------------------------------------

(defun shell-cmd (cmd)
  "Returns the stdout output of a shell command or nil if the command returned
   an error"
  (car (ignore-errors (apply 'process-lines (append `("sh" "-c") (list cmd))))))

(require 'reason-mode)
(require 'merlin)

(defun bucklescript-merlin (&optional global?)
  (let* ((refmt-bin (or (shell-cmd "which -a refmt | grep node")
                        (shell-cmd "which refmt")))
         (merlin-bin (or (shell-cmd "which -a ocamlmerlin |grep node")
                         'opam))
         (merlin-base-dir (when merlin-bin
                            (replace-regexp-in-string "bin/ocamlmerlin$" "" merlin-bin))))
    ;; Add npm merlin.el to the emacs load path and tell emacs where to find ocamlmerlin
    (when merlin-bin
      (add-to-list 'load-path (concat merlin-base-dir "share/pemacs/site-lisp/"))
      (if global?
          (setq merlin-command merlin-bin)
        (setq-local merlin-command merlin-bin)))
    (when refmt-bin
     (if global?
         (setq refmt-command refmt-bin)
       (setq-local refmt-command refmt-bin)))))

(defun reason-setup ()
  (bucklescript-merlin)
  (add-hook 'before-save-hook 'refmt-before-save)
  (merlin-mode))

(add-hook 'reason-mode-hook 'reason-setup)

(setq helm-dash-browser-func 'eww)
