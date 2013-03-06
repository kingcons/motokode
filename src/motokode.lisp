(in-package #:motokode)

;;; "motokode" goes here. Hacks and glory await!

(defun init-services ()
  (setf zs3:*credentials* (zs3:file-credentials ".aws"))
  (destructuring-bind (user pass) (read-lines ".github")
    (setf cl-github:*username* user
          cl-github:*password* pass))
  (let ((connect-args (read-lines ".postgres")))
    (apply 'postmodern:connect-toplevel connect-args)))
