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

(defun extract-tarball (file path)
  "Extract dir from FILE, rename dir to PATH, and delete FILE."
  (let ((output (inferior-shell:run/lines (format nil "tar zxvf ~a" file))))
    (rename-file (cl-fad:pathname-as-file (first output)) path)
    (delete-file file)))

(defun current-directory ()
  "Return the operating system's current directory."
  #+sbcl (sb-posix:getcwd)
  #+ccl (ccl:current-directory)
  #+ecl (si:getcwd)
  #+cmucl (unix:unix-current-directory)
  #+clisp (ext:cd)
  #-(or sbcl ccl ecl cmucl clisp) (error "Not implemented yet."))

(defun (setf current-directory) (path)
  "Change the operating system's current directory to PATH."
  #+sbcl (sb-posix:chdir path)
  #+ccl (setf (ccl:current-directory) path)
  #+ecl (si:chdir path)
  #+cmucl (unix:unix-chdir (namestring path))
  #+clisp (ext:cd path)
  #-(or sbcl ccl ecl cmucl clisp) (error "Not implemented yet."))

(defmacro with-current-directory (path &body body)
  "Change the current OS directory to PATH and execute BODY in
an UNWIND-PROTECT, then change back to the current directory."
  (alexandria:with-gensyms (old)
    `(let ((,old (current-directory)))
       (unwind-protect (progn
                         (setf (current-directory) ,path)
                         ,@body)
         (setf (current-directory) ,old)))))
