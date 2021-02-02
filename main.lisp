(in-package :transport)

(defun default-server-runp ()
  (server-runp))

(defun start-default-server ()
  (start-server))

(defun stop-default-server ()
  (stop-server))

(defun restart-default-server ()
  (restart-server))

(defun get-file (host port file))

(in-package :cl-user)
