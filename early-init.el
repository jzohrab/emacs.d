;; Hack to get rid of "Package cl is deprecated" warning.
;; https://github.com/kiwanami/emacs-epc/issues/35#issuecomment-773420321

(setq byte-compile-warnings '(cl-functions))
