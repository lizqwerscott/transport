(in-package :cl-user)

(defpackage :transport.head
  (:use :common-lisp :uiop)
  (:export
    :while
    :file-full-name
    :file-size
    :save-file
    :split-file
    :mapsplit))

(defpackage :transport.server
  (:use :common-lisp :uiop :uuid :transport.head :usocket :cl-json :flexi-streams :bordeaux-threads)
  (:export
    :get-default-server
    :server-runp
    :start-server
    :stop-server
    :restart-server))

(defpackage :transport
  (:use :common-lisp :uiop :transport.head :transport.server)
  (:export
    :default-server-runp
    :start-default-server
    :stop-default-server
    :restart-default-server
    :send-file
    :get-file))
