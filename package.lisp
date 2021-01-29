(in-package :cl-user)

(defpackage :transport.head
  (:use :common-lisp :uiop :uuid)
  (:export
    :while
    :file-full-name
    :file-size
    :save-file
    :split-file
    :mapsplit))

(defpackage :transport
  (:use :common-lisp :uiop :transport.head :usocket :cl-json :flexi-streams :bordeaux-threads)
  (:export
    :get-default-server
    :default-server-runp
    :start-default-server
    :stop-default-server
    :restart-default-server
    :send-file
    :get-file))
