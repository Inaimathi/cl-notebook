(in-package #:cl-notebook)

(define-json-handler (cl-notebook/notebook/export) ((book :notebook) (format :export-format))
  (hash
   :contents (export-as format book)
   :mimetype (mimetype-of format)
   :name (filename-of format book)))