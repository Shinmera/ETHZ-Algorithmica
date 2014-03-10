(declaim (optimize (speed 3) (safety 0) (debug 0))
         (ftype (function ((simple-array (signed-byte 12) 2)) (simple-array (signed-byte 12) 2)) compute-vertical-prefix-sums)
         (ftype (function ((simple-array (signed-byte 12) 2)) (unsigned-byte 13)) compute-max-submatrix-size))

(defvar *test-data* NIL)

(defun compute-vertical-prefix-sums (matrix)
  ;; Compute in-place, we don't need the original matrix.
  (let ((length (array-dimension matrix 0)))
    (loop for j of-type (unsigned-byte 7) from 0 below length
          do (loop for i of-type (unsigned-byte 7) from 1 below length
                   do (setf (aref matrix i j)
                            (+ (aref matrix (1- i) j)
                               (aref matrix i j))))))
  matrix)

(defun compute-max-submatrix-size (matrix)
  (compute-vertical-prefix-sums matrix)
  (let ((length (array-dimension matrix 0)))
    (declare (type (unsigned-byte 7) length))
    (loop with max of-type (signed-byte 14) = 0
          with min of-type (signed-byte 15) = 0
          with sub of-type (signed-byte 15) = 0
          for i of-type (unsigned-byte 7) from 0 below length
          do (loop for j of-type (unsigned-byte 7) from i below length
                   do (setf min 0 sub 0)
                      (loop for k of-type (unsigned-byte 7) from 0 below length
                            do (if (zerop i)
                                   (incf sub (aref matrix j k))
                                   (incf sub (- (aref matrix j k)
                                                (aref matrix (1- i) k))))
                               (when (< sub min)
                                 (setf min sub))
                               (when (< max (- sub min))
                                 (setf max (- sub min)))))
          finally (return max))))

;; Utilities

(defun read-test-data (&optional (path #p"~/Documents/dox/Exercises/datastructures and algorithms/ex3-hard.in"))
  (with-open-file (stream path :direction :input)
    (loop for nth-matrix from 0 below (read stream)
          collect (loop with size = (read stream)
                        with array = (make-array (list size size) :element-type '(signed-byte 12))
                        for nth-row from 0 below size
                        do (loop for nth-column from 0 below size
                                 do (setf (aref array nth-row nth-column) (read stream)))
                        finally (return array)))))

(defmacro exercise3 (&optional (matrices *test-data*))
  `(progn
     ,@(loop for matrix in matrices
             collect `(compute-max-submatrix-size
                       ;; have to copy at run-time to avoid clash with compute-vertical-prefix-sums modification.
                       (alexandria:copy-array ,matrix)))))

(defmacro exercise3-threaded (&optional (matrices *test-data*))
  (let ((threadsyms (loop  for i from 0 below (length matrices) collect (gensym (format NIL "THREAD-~d " i)))))
    `(let ,(loop for matrix in matrices
                 for thread in threadsyms
                 collect `(,thread (sb-thread:make-thread
                                    #'(lambda () (compute-max-submatrix-size
                                                  (alexandria:copy-array ,matrix))))))
       ,@(mapcar #'(lambda (thread) `(sb-thread:join-thread ,thread)) threadsyms))))

(defun run-hard ()
  (exercise3))

(defun run-hard-threaded ()
  (exercise3-threaded))

(setf *test-data* (read-test-data))
(run-hard)

;; Unoptimized run:
;; CL-USER> (with-timing 100 (run-hard))
;; Iterations: 100
;; Total real time: 169.195
;; Total run time:  169.983
;; Avg. real time:  1.6751981
;; Avg. run time:   1.683

;; First optimization pass with fixnums:
;; CL-USER> (with-timing 100 (run-hard))
;; Iterations: 100
;; Total real time: 40.58
;; Total run time:  40.913
;; Avg. real time:  0.40178218
;; Avg. run time:   0.40507922

;; Time for some more closely tied cheatin'
;; Iterations never go beyond 100.
;;   => 100
;;   Fits into (unsigned-byte 7)
;; Calculate maximum result:
;; (apply #'max (mapcar #'compute-max-submatrix-size *test-data*))
;;   => 5581
;;   Fits into (unsigned-byte 13)
;; Calculate maximum value in matrices:
;; (loop for matrix in *test-data*
;;       maximize (loop for i from 0 below (array-dimension matrix 0)
;;                      maximize (loop for j from 0 below (array-dimension matrix 0)
;;                                     maximize (aref matrix i j))))
;;   => 49
;; Calculate minimum value in matrices:
;; (loop for matrix in *test-data*
;;       minimize (loop for i from 0 below (array-dimension matrix 0)
;;                      minimize (loop for j from 0 below (array-dimension matrix 0)
;;                                     minimize (aref matrix i j))))
;;   => -50
;;   Fits into (signed-byte 7)
;; Calculate max/minimum value after vertical prefix summing:
;;   => 1120, -1158
;;   Fits into (signed-byte 12)
;; Have to do some more byte pushing to allow for boundary values in the loop.
;; Hence, we can determine the following types:
;; COUNTERS: (unsigned-byte 7)
;; ARRAY ELEMENT: (signed-byte 12)
;; RETURN VALUE: (unsigned-byte 13)
;; ARRAY-MAX: (signed-byte 14) ; can assume negative value, so sign and push up a byte.
;; ARRAY-MIN: (signed-byte 15) ; can assume bigger negative values, push up a byte.
;; ARRAY-SUB: (signed-byte 15)

;; Second optimization pass with close types:
;; CL-USER> (with-timing 100 (run-hard))
;; Iterations: 100
;; Total real time: 31.808
;; Total run time:  31.857
;; Avg. real time:  0.3149307
;; Avg. run time:   0.31541583

;; Using threaded runs:
;; CL-USER> (with-timing 100 (run-hard-threaded))
;; Iterations: 100
;; Total real time: 22.72
;; Total run time:  76.783
;; Avg. real time:  0.22495049
;; Avg. run time:   0.76022774
;; Sadly the overhead of creating and joining threads
;; doesn't seem to bring all that much profit in this case.
;; OH WELL.
