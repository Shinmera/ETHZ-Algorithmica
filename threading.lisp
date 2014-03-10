(defvar *working* 0)
(defvar *thread-pool* NIL)
(defvar *pool-queue* (sb-thread:make-waitqueue))
(defvar *pool-mutex* (sb-thread:make-mutex))
(defvar *queue* ())

(defun start-thread-pool (&optional (size 100))
  (setf *thread-pool* (make-array size :adjustable NIL :fill-pointer T))
  (let ((current-output *standard-output*))
    (loop for i from 0 below size
          do (setf (elt *thread-pool* i)
                   (sb-thread:make-thread
                    #'(lambda ()
                        (let ((*standard-output* current-output))
                          (pool-thread-fun))))))))

(defun stop-thread-pool ()
  (loop for thread across *thread-pool*
        do (when (sb-thread:thread-alive-p thread)
             (sb-thread:terminate-thread thread))))

(defun pool-thread-fun ()
  (sb-thread:with-mutex (*pool-mutex*)
    (loop
      (sb-thread:condition-wait *pool-queue* *pool-mutex*)
      (unless *queue* (return))
      (let ((func (pop *queue*)))
        (incf *working*)
        (sb-thread:release-mutex *pool-mutex*)
        (funcall func)
        (sb-thread:grab-mutex *pool-mutex*)
        (decf *working*)))))

(defun enqueue-job (function)
  (sb-thread:with-mutex (*pool-mutex*)
    (push function *queue*)
    (sb-thread:condition-notify *pool-queue*)))
