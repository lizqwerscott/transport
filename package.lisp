(in-package :cl-user)

(defpackage :transport.head
  (:use :common-lisp :uiop :uuid :bordeaux-threads)
  (:export
    :while
    ;;some others
    :error-f
    ;;about id
    :get-id
    ;;save-path
    :get-save-path
    ;;about file
    :file-full-name
    :file-size
    :save-file
    :split-file
    :mapsplit
    ;;about event
    :eventp
    :add-event
    :get-event
    :set-event
    :add-handle
    :fire-event))

(defpackage :transport.webhead
  (:use :common-lisp :uiop :transport.head :usocket :cl-json :flexi-streams)
  (:export
    :set-port
    :get-port
    :decode-head
    :get-data
    :generate-reply-head
    :generate-file-head
    :send-data))

(defpackage :transport.server
  (:use :common-lisp :uiop :transport.head :transport.webhead :usocket :flexi-streams :bordeaux-threads)
  (:export
    :server-runp
    :start-server
    :stop-server
    :restart-server))

(defpackage :transport.client
  (:use :common-lisp :uiop :transport.head :transport.webhead :transport.server)
  (:export
    :send-file))

(defpackage :transport
  (:use :common-lisp :uiop :transport.head :transport.server)
  (:export
    :default-server-runp
    :start-default-server
    :stop-default-server
    :restart-default-server
    :send-file
    ;:get-file
    
    ))
