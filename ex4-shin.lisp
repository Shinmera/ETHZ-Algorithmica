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

;; Faster using binary search insert
(defun find-place (value array)
  (let ((low 0)
        (high (1- (length array))))
    (do () ((< high low) nil)
      (let ((middle (floor (/ (+ low high) 2))))
        (cond ((and (= middle 0)
                    (> (aref array middle) value))
               (return 0))
              ((and (> (aref array middle) value)
                    (< (aref array (1- middle)) value))
               (return middle))
              ((> (aref array middle) value)
               (setf high (1- middle)))
              ((< (aref array middle) value)
               (setf low (1+ middle)))
              (t (return middle)))))))

(defun insert-sorted (item target)
  (vector-push-position item target (or (find-place item target) (fill-pointer target))))

(defun compute-fast (data)
  (let ((data (sort data #'<)))
    (declare ((vector fixnum) data))
    (loop with sum = 0
          while (< 2 (fill-pointer data))
          do (let ((limit (elt data (- (fill-pointer data) 3)))) ;; Third is our limiting factor
               (incf sum limit)
               (let ((el1 (- (vector-pop data) limit))
                     (el2 (- (vector-pop data) limit)))
                 (decf (fill-pointer data))
                 (insert-sorted el1 data)
                 (insert-sorted el2 data)))
          finally (return sum))))

;; Utils
(defun array-shift (array &key (n 1) (from 0) (to (length array)))
  (incf (fill-pointer array) n)
  (loop repeat (- to from)
        for cursor downfrom (1- to)
        do (setf (aref array (+ cursor n))
                 (aref array cursor)))
  array)

(defun vector-push-position (element vector position)
  (array-shift vector :from position)
  (setf (aref vector position) element))

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
        do (compute-fast dat)))
