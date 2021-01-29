(in-package :transport.server)

(defun decode-head (head)
  (json:decode-json-from-string (flexi-streams:octets-to-string head)))

(defun get-data (index lst)
  (cdr (find index lst :key (lambda (x)
                              (car x)))))

(defun send-message (host port data)
  (let ((socket (socket-connect host port :element-type 'character)))
    (unwind-protect
      (progn
        (format (socket-stream socket) "finish"))
      (socket-close socket))))

(defclass server ()
  ((id
     :initform (make-v1-uuid)
     :accessor server-id)
   (socket-server-thread
     :initform nil
     :accessor ss-thread)
   (save-dir
     :initarg :save-dir
     :initform (pathname "/home/lizqwer/temp/tcp/")
     :accessor server-dir)
   (port
     :initarg :port
     :initform 2254
     :accessor server-port)))

(defmethod run-server (stream (server-one server))
  (format t "Create the connection:~%")
  (format t "IP:~A, Port:~A~%" *remote-host* *remote-port*)
  (let ((head (make-array (read-byte stream) :initial-element nil)))
    (read-sequence head stream)
    (format t "head-len:~A~%" (length head))
    (format t "head:~%~A~%----------~%" (octets-to-string head))
    (let ((head-json (decode-head head)))
      (format t "head-json:~%~A---------~%" head-json)
      (format t "i-size:~A~%" (get-data :isize head-json))
      (if (string= "sendFile" (get-data :command head-json))
          (let ((data (make-array (get-data :isize head-json) :initial-element nil)))
            (format t "Starting recive~%")
            (read-sequence data stream)
            (save-file (get-data :name head-json) data)
            (format t "Finish~%"))
          (format t "not the sendFile"))))
  (send-message "127.0.0.1" 2273 "finish"))

(defmethod server-runp ((server-one server))
  (let ((thread (ss-thread server-one)))
    (and thread (thread-alive-p thread))))

(defmethod start-server ((server-one server))
  (when (not (server-runp server-one))
      (setf (ss-thread server-one) (socket-server "127.0.0.1" (server-port server-one) #'run-server (list server-one) :in-new-thread t :multi-threading t :element-type :default))))

(defmethod stop-server ((server-one server))
  (when (server-runp server-one)
    (setf (ss-thread server-one) (destroy-thread (ss-thread server-one)))))

(defmethod restart-server ((server-one server))
  (stop-server server-one)
  (start-server server-one))

(defvar *server* (make-instance 'server :port 2256))

(defun get-default-server ()
  *server*)

(in-package :cl-user)
