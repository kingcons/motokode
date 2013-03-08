(defpackage :motokode.github
  (:use :cl)
  (:export #:save-repo
           #:save-gist))

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
