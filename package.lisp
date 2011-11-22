;;;; package.lisp

(defpackage #:webscraper
  (:use #:cl)
  (:documentation "Half-baked web scraping library.")
  (:export #:=and
           #:=or
           #:=not
           #:=type-is
           #:=elementp
           #:=after
           #:=before
           #:=name-is
           #:=attribute-is
           #:=attribute-matches
           #:first-matching
           #:with-first-match
           #:url-content))

(defpackage #:webscraper-user
  (:use #:cl #:webscraper))

