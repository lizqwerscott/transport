(in-package :transport.head)

(defvar *MB* (* 1024 1024))
(defvar *KB* 1024)

(let ((save-path (pathname "/home/lizqwer/temp/tcp/")))
  (defun get-save-path ()
    save-path))

;;TODO 本地启动需要改变不同的目录，不然id冲突
(let ((id-path (pathname "/home/lizqwer/temp/transport/id.txt"))
      (id 0))
  (labels ((save-id-file (path id)
             (with-open-file (file path 
                                   :direction :output 
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
               (print id file))
             id)
           (get-id-file (path)
             (with-open-file (file path)
               (read file))))
    (if (probe-file id-path)
      (setf id (get-id-file id-path))
      (setf id (save-id-file id-path (uuid:make-v1-uuid)))))
  (defun get-id ()
    id))

(defmacro while (test &rest body)
  `(do ()
       ((not ,test))
       ,@body))

(defun file-full-name (file)
  (format nil "~A.~A" (pathname-name file) (pathname-type file)))

(defun file-size (path)
  (with-open-file (file path)
    (file-length file)))

(defun split-file (path &optional (dstep *MB*))
  (with-open-file (file path :element-type '(unsigned-byte 8))
    (let ((size (ceiling (/ (file-length file) dstep))))
      (format t "All Size:~A, Size:~A~%" (file-length file) size)
      (do ((i 0 (+ i 1))
           (datas nil))
          ((= i size) datas)
          (let ((data (make-array (if (not (= i (- size 1))) dstep
                                      (- (file-length file) (* i dstep))) 
                                  :initial-element nil)))
            (setf datas (append datas (list data)))
            (read-sequence data file))))))

(defun save-file (name data)
  (with-open-file (file (format nil "~A~A" (get-save-path) name) 
                        :element-type '(unsigned-byte 8) 
                        :direction :output
                        :if-exists :append
                        :if-does-not-exist :create)
    (write-sequence data file)))

(defun mapsplit (lst dstep func)
  (if (and lst (integerp dstep) (> dstep 0)) 
    (let ((le (/ (length lst) dstep)))
      (if (< le 1) 
          (funcall func lst)
          (doTimes (i (ceiling le))
                   (funcall func (subseq lst (* i dstep) (if (= i (- (ceiling le) 1))
                                                             (if (= i (truncate le))
                                                                 (length lst)
                                                                 (* (+ i 1) dstep))
                                                             (* (+ i 1) dstep)))))))))

(defun error-f (funcition info)
  (format t "[~A]:~A~%" funcition info) nil)

(let ((event-list (make-hash-table :test 'equal)))
  (defun eventp (name)
    (multiple-value-bind (value present) (gethash name event-list) present))
  (defun add-event (name datal)
    (multiple-value-bind (value present) (gethash name event-list)
      (if (not present)
          (setf (gethash name event-list) (list :func nil :data datal))
          (error-f "add-event" (format nil "~A already add" name)))))
  (defun get-event (name)
    (multiple-value-bind (value present) (gethash name event-list)
      (if present value
          (error-f "get-event" (format nil "~A is not add" name)))))
  (defun set-event (name datal)
    (multiple-value-bind (value present) (gethash name event-list)
      (if present
          (let ((event (car (gethash name event-list))))
            (setf (getf (gethash name event-list) :data) datal))
          (error-f "set-event" (format nil "~A is not add" name)))))
  (defun add-handle (name func)
    (multiple-value-bind (value present) (gethash name event-list)
      (if present
          (setf (getf (gethash name event-list) :func) func)
          (error-f "add-handle" (format nil "~A is not add" name)))))
  (defun fire-event (name &rest argument)
    (multiple-value-bind (value present) (gethash name event-list)
      (if present
          (make-thread (lambda () 
                         (apply (getf value :func) argument)) :name name)
          (error-f "add-handle" (format nil "~A is not add" name))))))

(in-package :cl-user)
