(declaim (optimize (speed 3) (safety 0) (debug 0))
         (ftype (function ((vector fixnum)) fixnum) compute)
         (list *test*))

;; Slow as balls.
(defun compute (data)
  (let ((data (the (vector fixnum) (sort data #'>))))
    (declare ((vector fixnum) data))
    (loop with sum = 0
          while (< 2 (fill-pointer data))
          do (let ((limit (elt data 2))) ;; Third is our limiting factor
               (incf sum limit)
               (decf (elt data 0) limit)
               (decf (elt data 1) limit)
               (setf (elt data 2) 0))
             (setf data (the (vector fixnum) (sort data #'>))) ; Sort highest first
             (loop while (and (< 0 (fill-pointer data))
                              (= (elt data (1- (fill-pointer data))) 0))
                   do (decf (fill-pointer data))) ; Pop here so we have to sort less
          finally (return sum))))

;; Utils
(defun read-test-data (&optional (path #p"~/Documents/dox/Exercises/datastructures and algorithms/ex4-hard.in"))
  (with-open-file (stream path :direction :input)
    (loop repeat (read-from-string (read-line stream))
          for line = (read-line stream)
          collect (loop with size = (parse-integer line :junk-allowed T)
                        with array = (make-array size :element-type 'fixnum :fill-pointer 0)
                        with data = (make-string-input-stream (read-line stream))
                        repeat size do (vector-push (read data) array)
                        finally (return array)))))

(defparameter *test* (read-test-data))

(defun test-hard ()
  (loop for dat in *test*
        do (compute dat)))
