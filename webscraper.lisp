;;;; webscraper.lisp

(in-package #:webscraper)

;;; "webscraper" goes here. Hacks and glory await!

(defun =callfun (node)
  "Return a function suitable for mapping over a list of functions to
call each one of them on NODE."
  (lambda (fun)
    (funcall fun node)))

(defun =and (&rest conditions)
  "Return a function that takes a node argument and returns true if
each function in CONDITIONS returns true."
  (lambda (node)
    (every (=callfun node) conditions)))

(defun =or (&rest conditions)
  "Return a function that takes a node argument and returns true if
any function in CONDITIONS returns true."
  (lambda (node)
    (some (=callfun node) conditions)))

(defun =not (condition)
  (complement condition))

(defun =type-is (type)
  (lambda (node)
    (typep node type)))

(defun =elementp ()
  (=type-is 'stp:element))

(defun =after (fun)
  (let ((condition nil))
    (lambda (node)
      (or condition
          (setf condition (funcall fun node))))))

(defun =before (fun)
  (let ((condition t))
    (lambda (node)
      (if (not condition)
          t
          (when (funcall fun node)
            (setf condition nil))))))

(defun =name-is (name)
  (=and (=elementp)
        (lambda (node)
          (string= (stp:local-name node) name))))

(defun =attribute-is (attribute value)
  (=and (=elementp)
        (lambda (node)
          (let ((actual-value (stp:attribute-value node attribute)))
            (when actual-value
              (string= value actual-value))))))

(defun =attribute-matches (attribute regex)
  (let ((scanner (ppcre:create-scanner regex)))
    (lambda (node)
      (let ((value (stp:attribute-value node attribute)))
        (when value
          (ppcre:scan scanner value))))))

(defun first-matching (predicate document)
  (stp:find-recursively-if predicate document))

(defmacro with-first-match ((node doc) predicate &body body)
  `(when-let ((,node (first-matching ,predicate ,doc)))
     ,@body))

(defun url-content (url)
  (drakma:http-request url :user-agent :safari))
