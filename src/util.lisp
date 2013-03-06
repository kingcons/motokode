(in-package :motokode)

(defun read-credentials (file)
  (with-open-file (in file)
    (loop for line = (read-line in nil) while line collect line)))
