(defpackage :motokode.author
  (:use :cl)
  (:import-from :postmodern #:insert-dao
                            #:get-dao)
  (:export #:author
           #:import-author
           #:maybe-import-author))

(in-package :motokode.author)

(defclass author ()
  ((name :col-type string :initarg :name
         :accessor author-name)
   (email :col-type string :initarg :email
          :accessor author-email)
   (alias :col-type string :initarg :alias
          :accessor author-alias)
   (readers :col-type integer :col-default 0
            :accessor author-readers)
   (company :col-type string :initarg :company
            :accessor author-company)
   (website :col-type string :initarg :website
            :accessor author-website)
   (location :col-type string :initarg :location
             :accessor author-location))
  (:metaclass postmodern:dao-class)
  (:keys alias))

(defgeneric import-author (id)
  (:documentation "Import author metadata from github, if available.")
  (:method ((id string))
    (alexandria:if-let (result (github-user:get-user :id id))
      (insert-dao (make-instance 'author :name (getf result :name)
                                         :email (getf result :email)
                                         :alias (getf result :login)
                                         :company (getf result :company)
                                         :website (getf result :blog)
                                         :location (getf result :location)))
      (error 'no-such-author))))

(defun maybe-import-author (author)
  "Check if AUTHOR has already been imported. If not, import the AUTHOR."
  (unless (get-dao 'author author)
    (import-author author)))
