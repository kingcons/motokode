(defpackage motokode.user
  (:use :cl)
  (:export #:user))

(in-package :motokode.user)

(defclass user ()
  ((bio :initarg :bio :col-type string
        :accessor user-bio)
   (name :initarg :name :col-type string
         :accessor user-name)
   (email :initarg :email :col-type string
          :accessor user-email)
   (website :initarg :website :col-type string
            :accessor user-website)
   (username :initarg :username :col-type string
             :accessor user-username)
   (password :initarg :password :col-type string
             :accessor user-password)
   (salt :initarg :salt :col-type string
         :accessor user-salt))
  (:metaclass postmodern:dao-class)
  (:keys email))

;; TODO: ratings, memberships, reading/following?
