(defpackage :motokode.db
  (:use :cl :motokode)
  (:import-from :motokode.author #:author)
  (:import-from :motokode.code #:code
                               #:project
                               #:snippet
                               #:raw)
  (:import-from :motokode.user #:user)
  (:import-from :postmodern #:deftable
                            #:!dao-def
                            #:!foreign))

(in-package :motokode.db)

(deftable author (!dao-def))

(deftable code
  (!dao-def)
  (!foreign 'author 'author :primary-key))

(deftable project (!dao-def))
(deftable snippet (!dao-def))
(deftable raw (!dao-def))

(deftable user (!dao-def))
