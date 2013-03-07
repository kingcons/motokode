(defpackage :motokode.s3
  (:use :cl)
  (:export #:extract-and-upload))

(in-package :motokode.s3)

(defun upload (filepath dir bucket)
  "Upload FILEPATH under DIR to the given BUCKET."
  (let ((key (enough-namestring filepath dir)))
    (zs3:put-file filepath bucket key :public t)))

(defun sync-dir (dir bucket)
  "Sync DIR to a BUCKET on S3. Bucket should be one of :project, :snippet, :raw."
  (let ((bucket (ecase bucket
                  (:project "project.motokode.com")
                  (:snippet "snippet.motokode.com")
                  (:raw "raw.motokode.com"))))
    (cl-fad:walk-directory dir (lambda (f) (upload f dir bucket)))))

(defun extract-and-upload (tarball path &optional (bucket :project))
  "Extract the TARBALL of code to PATH and upload it to BUCKET on S3."
  (motokode:extract-tarball tarball path)
  (sync-dir path bucket)
  (motokode:run-program "rm -rf ~a" path))
