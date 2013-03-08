(defpackage :motokode.github
  (:use :cl)
  (:import-from :alexandria #:when-let*)
  (:export #:save-repo
           #:save-gist
           #:get-repo
           #:get-gist))

(in-package :motokode.github)

(defun save-repo (owner repo path)
  "Save OWNER's REPO to PATH under (current-directory)."
  (let ((bytes (github-repo:get-archive :owner owner :repo repo)))
    (alexandria:write-byte-vector-into-file bytes path)))

(defun save-gist (url path)
  "Save the gist at URL to PATH under (current-directory)."
  ;; KLUDGE: Github's API lacks a gist get. Completely naive fetch.
  (let ((bytes (drakma:http-request (format nil "~a/download" url))))
    (alexandria:write-byte-vector-into-file bytes path)))

(defun get-repo (id)
  (destructuring-bind (owner repo) id
    (when-let* ((result (github-repo:get-repository :owner owner :repo repo))
                (author (getf (getf result :owner) :login)))
      (list :author author
            :name (getf result :name)
            :url (getf result :html-url)
            :language (getf result :language)
            :description (getf result :description)))))

(defun get-gist (id)
  (when-let* ((result (github-gist:get-gist :id id))
              (author (getf (getf result :user) :login))
              (files (rest (getf result :files))))
    (list :author author
          :name id
          :url (getf result :html-url)
          :language (getf (first files) :language)
          :description (getf result :description))))
