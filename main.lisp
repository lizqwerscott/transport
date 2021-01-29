(in-package :transport)

(defun default-server-runp ()
  (server-runp (get-default-server)))

(defun start-default-server ()
  (start-server (get-default-server)))

(defun stop-default-server ()
  (stop-server (get-default-server)))

(defun restart-default-server ()
  (restart-server (get-default-server)))

(defun send-file (host port path))

(defun get-file (host port file))

(in-package :cl-user)
