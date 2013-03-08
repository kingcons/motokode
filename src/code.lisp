(defpackage :motokode.code
  (:use :cl)
  (:import-from :alexandria #:when-let*)
  (:import-from :postmodern #:insert-dao)
  (:export #:code #:project #:snippet #:raw))

(in-package :motokode.code)

;; github repo has:
;; FORK - we probably want to only pull in original stuff, not forks
;; collaborators?
;; readers!
;; forks count, watchers count
;; created, updated
;; size

;; github gist has:
;; created, updated
;; files/content
;;; size

(defclass code ()
  ((url :col-type string :initarg :url
        :accessor code-url)
   (name :col-type string :initarg :name
         :accessor code-name)
   (author :col-type string :initarg :author
           :accessor code-author)
   (language :col-type (or string db-null) :initarg :language
             :accessor code-language)
   (description :col-type (or string db-null) :initarg :description
                :accessor code-description))
  (:metaclass postmodern:dao-class)
  (:keys url))

(defclass project (code) ()
  (:metaclass postmodern:dao-class))

(defclass snippet (code) ()
  (:metaclass postmodern:dao-class))

(defclass raw (code) ()
  (:metaclass postmodern:dao-class))

(defun highlight (file)
  "Syntax highlight FILE using Python's Pygments."
  (motokode:run-program "pygmentize -O linenos=table -f html ~a" file))

(defgeneric import-code (code)
  (:documentation "Create a DAO object for CODE, then call save-and-upload on it.")
  (:method :around (code)
    (motokode:with-current-directory #P"/tmp/" (call-next-method))))

(defgeneric persist (code)
  ;; NOTE: We don't use initialize-instance :after methods here as they would
  ;; get called every time CODE was retrieved from the database.
  (:documentation "Save CODE to the database and mirror the source to S3.")
  (:method :before (code) (insert-dao code)))

(defmethod import-code ((id string))
  (when-let* ((result (github-gist:get-gist :id id))
              (author (getf (getf result :user) :login))
              (files (rest (getf result :files))))
    (motokode.author:maybe-import-author author)
    (let ((code (make-instance 'snippet :url (getf result :html-url)
                                        :name id
                                        :author author
                                        :language (getf (first files) :language)
                                        :description (getf result :description))))
      (persist code))))

(defmethod persist ((code snippet))
  (with-accessors ((author code-author)) code
    (motokode.github:save-gist (code-url code) "gist.tar.gz")
    (let ((destination (format nil "~a-~a" author (code-name code))))
      (motokode.s3:extract-and-upload "gist.tar.gz" destination :snippet))))

(defmethod import-code ((id list))
  (destructuring-bind (owner repo) id
    (when-let* ((result (github-repo:get-repository :owner owner :repo repo))
                (author (getf (getf result :owner) :login)))
      (motokode.author:maybe-import-author author)
      (let ((code (make-instance 'project :url (getf result :html-url)
                                          :name (getf result :name)
                                          :author author
                                          :language (getf result :language)
                                          :description (getf result :description))))
        (persist code)))))

(defmethod persist ((code project))
  (with-accessors ((author code-author)
                   (name code-name)) code
    (motokode.github:save-repo author name "repo.tar.gz")
    (let ((destination (format nil "~a-~a" author name)))
      (motokode.s3:extract-and-upload "repo.tar.gz" destination))))
