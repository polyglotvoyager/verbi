(defpackage :verbi
  (:use :cl)
  (:export #:generate-site))

(asdf:defsystem "verbi"
  :version "0.0.1"
  :author "Heitor Chang"
  :license "MIT"
  :components ((:module "src"
                :components
                ((:file "site-generator")
                 (:file "utils"))))
  :description "Verb conjugation practice")
