(in-package :verbi)

;; add trailing slash!
(defparameter *templates-dir* "/home/sandbox/common-lisp/verbi/templates/")
(defparameter *data-dir* "/home/sandbox/common-lisp/verbi/data/")
(defparameter *output-dir* "/home/sandbox/common-lisp/verbi/site/")

(defun output-path (filename)
  (concatenate 'string *output-dir* filename))

(defmacro write-out (filename content)
  `(with-open-file (out (output-path ,filename)
			:direction :output
			:if-exists :supersede)
     (format out "~A" ,content)))

(defun generate-site ()
  (ensure-directories-exist *output-dir*)
  (write-out "index.html" "hello verbi"))
