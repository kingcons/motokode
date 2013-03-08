(asdf:defsystem #:motokode
  :name "motokode"
  :description "A Code Reading Site"
  :author "Brit Butler <redline6561@gmail.com>"
  :license "BSD"
  :version "0.0.1"
  :pathname "src/"
  :serial t
  :depends-on (:restas
               :postmodern
               :closure-template
               :inferior-shell
               :alexandria
               :cl-fad
               :zs3
               :cl-github-v3)
  :components ((:file "package")
               (:file "util")
               (:file "s3")
               (:file "github")
               (:file "author")
               (:file "code")
               (:file "user")
               (:file "reader")
               (:file "tables")
               (:file "motokode"))
  :in-order-to ((test-op (load-op famiclom-tests)))
  :perform (test-op :after (op c)
                    (funcall (intern "RUN!" :motokode-tests)
                             (intern "MOTOKODE-TESTS" :motokode-tests))))

(defsystem #:motokode-tests
  :depends-on (:motokode :fiveam)
  :pathname "tests/"
  :serial t
  :components ((:file "tests")))

(defpackage #:motokode-conf (:export #:*basedir*))
(defvar motokode-conf:*basedir*
  (make-pathname :defaults *load-truename* :name nil :type nil))
