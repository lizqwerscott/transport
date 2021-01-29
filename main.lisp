(in-package :transport)

(defparameter *server* (make-instance 'server :port 2256))

(defun get-default-server ()
  *server*)

(defun default-server-runp ()
  (server-runp *server*))

(defun start-default-server ()
  (start-server *server*))

(defun stop-default-server ()
  (stop-server *server*))

(defun restart-default-server ()
  (restart-server *server*))

(defun send-file (host port path))

(defun get-file (host port file))

(in-package :cl-user)
