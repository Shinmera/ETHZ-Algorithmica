(defun make-heap (&optional (size 0))
  (make-array size :adjustable T :fill-pointer 0))

(defun parent (pos)
  (floor (/ (1- pos) 2)))

(defun min-child (heap pos)
  (let ((foo (1+ (* 2 pos))))
    (unless (< foo (fill-pointer heap))
      (return-from min-child -1))
    (if (< (1+ foo) (fill-pointer heap))
        (if (< (aref heap foo)
               (aref heap (1+ foo)))
            foo (1+ foo))
        foo)))

(defun swap (heap p1 p2)
  (let ((el (aref heap p1)))
    (setf (aref heap p1) (aref heap p2)
          (aref heap p2) el)))

(defun insert (heap item)
  (vector-push-extend item heap)
  (loop for current = (1- (fill-pointer heap))
          then parent
        until (= current 0)
        for parent = (parent current)
        until (< (aref heap parent)
                 (aref heap current))
        do (swap heap parent current)))

(defun extract (heap)
  (swap heap 0 (1- (fill-pointer heap)))
  (prog1 (vector-pop heap)
    (loop for current = 0
            then child
          for child = (min-child heap current)
          until (or (= -1 child)
                    (<  (aref heap current)
                        (aref heap child)))
          do (swap heap child current))))

(defun query-last (heap)
  (aref heap (1- (fill-pointer heap))))

(defun insert-many (heap &rest items)
  (loop for i in items do (insert heap i)))

(defun exercise5 (data)
  (let ((heap (make-heap)))
    (loop for dat in data
          for i from 0
          do (insert heap dat)
             (format T "~a " (query-last heap))
          finally (progn
                    (format T "~%")
                    (loop for j downfrom i to 0
                          do (format T "~a " (extract heap)))))))
