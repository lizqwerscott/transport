(in-package :transport.head)

(defvar *MB* (* 1024 1024))
(defvar *KB* 1024)
(defparameter *save-path* "/home/lizqwer/temp/tcp/")

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
  (with-open-file (file (format nil "~A~A" *save-path* name) 
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

(in-package :cl-user)
