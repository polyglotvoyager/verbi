(in-package :verbi)

;; add trailing slash!
(defparameter *templates-dir* "/home/sandbox/common-lisp/verbi/templates/")
(defparameter *data-dir* "/home/sandbox/common-lisp/verbi/data/")
(defparameter *output-dir* "/home/sandbox/common-lisp/verbi/site/")

(defun output-path (filename)
  (concatenate 'string *output-dir* filename))

(defun data-path (infinito)
  (concatenate 'string *data-dir* infinito ".lisp"))

(defun template-path (infinito)
  (concatenate 'string *templates-dir* infinito))

(defmacro write-out (filename content)
  `(with-open-file (out (output-path ,filename)
			:direction :output
			:if-exists :supersede)
     (format out "~A" ,content)))

(defmacro load-data (infinito)
  `(with-open-file (in (data-path ,infinito))
     (with-standard-io-syntax
       (read in))))

(defun load-template (filename)
  (uiop:read-file-string (template-path filename)))

(defun split-words (words-string)
  "Add an empty string as the 0th element"
  (format nil "['', ~{'~A', ~}]"
	  (loop for i = 0 then (1+ j)
		as j = (position #\Space words-string :start i)
		collect (subseq words-string i j)
		while j)))

(defun js-tempo (lisp-tempo)
  (format nil
	  "'~A': ~A"
	  (car lisp-tempo)
	  (split-words (cadr lisp-tempo))))

(defun js-modo (lisp-modo)
  (format nil
	  "  '~A':~%    {~%~{      ~A,~%~}    },~%"
	  (car lisp-modo)
	  (mapcar #'js-tempo (cdr lisp-modo))))

(defun js-conjugation (lisp-data)
  (format nil
	  "const data = {~%~{~A~}  }"
	  (mapcar #'js-modo (cadr lisp-data))))

(defun generate-verbo (infinito)
  (let ((data (load-data infinito)))
    (format nil (load-template "verbo.html")
	    (car data)
	    (js-conjugation data))))

(defun generate-index ()
  (format nil (load-template "index.html")
	  "Lista di verbi"))

(defun generate-site ()
  (ensure-directories-exist *output-dir*)
  (write-out "index.html" (generate-index))
  (write-out "essere.html" (generate-verbo "essere")))
