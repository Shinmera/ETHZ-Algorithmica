(defvar *working* 0)
(defvar *jobs-done* 0)
(defvar *thread-pool* NIL)
(defvar *pool-queue* (sb-thread:make-waitqueue))
(defvar *pool-mutex* (sb-thread:make-mutex))
(defvar *queue* NIL)

(defun start-thread-pool (&optional (size 100) (queue 100))
  (setf *thread-pool* (make-array size :adjustable NIL :fill-pointer 0)
        *queue* (make-array queue :adjustable T :fill-pointer 0)
        *jobs-done* 0
        *working* 0)
  (let ((current-output *standard-output*))
    (loop repeat size
          do (vector-push
              (sb-thread:make-thread
               #'(lambda ()
                   (let ((*standard-output* current-output))
                     (pool-thread-fun))))
              *thread-pool*))))

(defun stop-thread-pool ()
  (loop for thread across *thread-pool*
        do (when (sb-thread:thread-alive-p thread)
             (sb-thread:terminate-thread thread))))

(defun pool-thread-fun ()
  (sb-thread:with-mutex (*pool-mutex*)
    (loop
      (if (< 0 (length *queue*))
          (let ((func (vector-pop *queue*)))
            (incf *working*)
            (sb-thread:release-mutex *pool-mutex*)
            (funcall func)
            (sb-thread:grab-mutex *pool-mutex*)
            (incf *jobs-done*)
            (decf *working*))
          (sb-thread:condition-wait *pool-queue* *pool-mutex*)))))

(defun enqueue-job (function)
  (sb-thread:with-mutex (*pool-mutex*)
    (vector-push-extend function *queue*)
    (sb-thread:condition-notify *pool-queue*)))
