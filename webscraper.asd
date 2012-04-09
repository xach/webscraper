;;;; webscraper.asd

(asdf:defsystem #:webscraper
  :serial t
  :description "Half-baked web-scraping library."
  :depends-on (#:drakma
               #:cxml-stp
               #:cl-ppcre)
  :components ((:file "package")
               (:file "webscraper")))

