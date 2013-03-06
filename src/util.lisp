(in-package :motokode)

(defun fmt (fmt-str &rest args)
  "A shorthand for string formatting."
  (apply 'format nil fmt-str args))

(defun read-lines (file)
  "Collects each line in FILE into a list."
  (with-open-file (in file)
    (loop for line = (read-line in nil) while line collect line)))

(defun run-program (program &rest args)
  "Take a PROGRAM and execute the corresponding shell command. If ARGS is
provided, use (fmt PROGRAM ARGS) as the value of PROGRAM."
  (inferior-shell:run/ss (fmt program args) :show t))
