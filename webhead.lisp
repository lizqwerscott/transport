(in-package :transport.webhead)

(let ((port 0))
  (defun set-port (p)
    (setf port p))
  (defun get-port ()
    port))

(defun generate-head (lst)
  (string-to-octets (encode-json-to-string lst)))

(defun decode-head (head)
  (decode-json-from-string (octets-to-string head)))

(defun get-data (index lst)
  (cdr (find index lst :key (lambda (x)
                              (car x)))))

(defun generate-file-head (file allLength isize index)
  (generate-head `(("command" . "sendFile")
                   ("sender" . ,(get-id))
                   ("port" . ,(get-port))
                   ("return" . t)
                   ("name" . ,(file-full-name file))
                   ("size" . ,(file-size file))
                   ("alllength" . ,allLength)
                   ("isize" . ,isize)
                   ("index" . ,index))))

(defun generate-reply-head (size)
  (generate-head `(("command" . "reply")
                   ("sender" . ,(get-id))
                   ("return" . nil)
                   ("size" . ,size)))) 

(defun send-data (host port head data)
  (let ((socket (socket-connect host port :element-type :default)))
    (unwind-protect
      (progn
        (write-byte (length head) (socket-stream socket))
        (write-sequence head (socket-stream socket))
        (format t "[send-data]:data start send~%")
        (write-sequence data (socket-stream socket))
        (format t "[send-data]:data start end~%"))
      (socket-close socket))))

(in-package :cl-user)
