(in-package :motokode)

(defclass author ()
  ((name :col-type string :initarg :name :accessor author-name)
   (email :col-type string :initarg :email :accessor author-email)
   (alias :col-type string :initarg :alias :accessor author-alias)
   (readers :col-type integer :col-default 0 :accessor author-readers)
   (company :col-type string :initarg :company :accessor author-company)
   (website :col-type string :initarg :website :accessor author-website)
   (location :col-type string :initarg :location :accessor author-location))
  (:metaclass postmodern:dao-class)
  (:keys email))

