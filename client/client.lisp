(in-package :transport.client)
;;;;TODO 创建一个任务链表，让任务在里面自由进行（多线程）

(add-event "wait-reply" (list "127.0.0.1"))

(defun wait-reply (host reply)
  (set-event "wait-reply" (list host))
  (let ((r-reply ""))
    (add-handle "wait-reply" 
                (lambda (g-reply)
                  (setf r-reply g-reply)))
    (do ((i 0 (+ 1 i)))
        ((string= r-reply reply) r-reply)
        (sleep 1))))

(defun send-file (host port path)
  (let ((file (pathname path))
        (datas (split-file path))) 
    (let ((allLength (length datas)))
      (doTimes (i allLength)
               (format t "~Astart~%" i)
               (let ((head (generate-file-head file allLength (length (elt datas i)) i)))
                 (send-data host port head (elt datas i)))
               (format t "wait1~%")
               (wait-reply host "finish")
               (format t "wait2~%")))))

;;TODO need get the return
(defun add-network (host port)
  (send-data host port (generate-add-head) nil))

(in-package :cl-user)
