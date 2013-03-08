(in-package :motokode.models)

(defclass reader ()
  ((user :initarg :user :col-type string
         :accessor reader-user)
   (code :initarg :code :col-type string
         :accessor reader-code))
  (:metaclass postmodern:dao-class)
  (:keys user code))
