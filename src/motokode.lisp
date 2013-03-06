(in-package #:motokode)

;;; "motokode" goes here. Hacks and glory await!

(defun init-services ()
  (destructuring-bind (user pass) (read-credentials ".github")
    (setf cl-github:*username* user
          cl-github:*password* pass))
  (let ((connect-args (read-credentials ".postgres")))
    (apply 'postmodern:connect-toplevel connect-args)))
