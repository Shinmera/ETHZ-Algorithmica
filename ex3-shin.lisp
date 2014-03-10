(defvar *test-data* NIL)

(defun compute-vertical-prefix-sums (matrix)
  ;; Compute in-place, we don't need the original matrix.
  (let ((length (array-dimension matrix 0)))
    (loop for j from 0 below length
          do (loop for i from 1 below length
                   do (setf (aref matrix i j)
                            (+ (aref matrix (1- i) j)
                               (aref matrix i j))))))
  matrix)

(defun compute-max-submatrix-size (matrix)
  (compute-vertical-prefix-sums matrix)
  (let ((length (array-dimension matrix 0)))
    (loop with max = 0
          with min = 0
          with sub = 0
          for i from 0 below length
          do (loop for j from i below length
                   do (setf min 0 sub 0)
                      (loop for k from 0 below length
                            do (if (zerop i)
                                   (incf sub (aref matrix j k))
                                   (incf sub (- (aref matrix j k)
                                                (aref matrix (1- i) k))))
                               (when (< sub min)
                                 (setf min sub))
                               (when (< max (- sub min))
                                 (setf max (- sub min)))))
          finally (return max))))

;; utilities

(defun read-test-data (&optional (path #p"~/Documents/dox/Exercises/datastructures and algorithms/ex3-hard.in"))
  (with-open-file (stream path :direction :input)
    (loop for nth-matrix from 0 below (read stream)
          collect (loop with size = (read stream)
                        with array = (make-array (list size size) :element-type 'fixnum)
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

(defun run-hard ()
  (exercise3))

(setf *test-data* (read-test-data))
(run-hard)

;; Unoptimized run:
;; CL-USER> (with-timing 100 (run-hard))
;; Iterations: 100
;; Total real time: 169.195
;; Total run time:  169.983
;; Avg. real time:  1.6751981
;; Avg. run time:   1.683
