(in-package :motokode)

;; github repo has:
;; FORK - we probably want to only pull in original stuff, not forks
;; forks count, watchers count
;; created, updated
;; size

;; github gist has:
;; created, updated
;; files/content
;;; size

(defclass code ()
  ((url :col-type string :initarg :url :accessor code-url)
   (author :col-type string :initarg :author :accessor code-author)
   (readers :col-type integer :col-default 0 :accessor code-readers)
   (language :col-type string :initarg :language :accessor code-language)
   (description :col-type string :initarg :description :accessor code-description))
  (:metaclass postmodern:dao-class)
  (:keys url))

(defclass project (code)
  ((name :col-type string :initarg :name :accessor project-name)
   (collaborators :col-type string :initarg :collaborators :accessor project-collaborators))
  (:metaclass postmodern:dao-class))

(defclass snippet (code) ()
  (:metaclass postmodern:dao-class))

(defclass raw (code)
  ((content :col-type string :initarg :content :accessor raw-content))
  (:metaclass postmodern:dao-class))
