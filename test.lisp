(defmacro time-spent (&body body)
  "Returns three values: the return of the last body form, the real time passed and the run time passed."
  (let ((real1 (gensym)) (real2 (gensym)) (run1 (gensym)) (run2 (gensym)) (result (gensym)))
    `(let* ((,real1 (get-internal-real-time))
            (,run1 (get-internal-run-time))
            (,result (progn ,@body))
            (,real2 (get-internal-real-time))
            (,run2 (get-internal-run-time)))
       (declare (fixnum ,real1 ,run1 ,real2 ,run2))
       (values ,result 
               (/ (- ,real2 ,real1) internal-time-units-per-second)
               (/ (- ,run2 ,run1) internal-time-units-per-second)))))

(defmacro with-timing (iterations &body body)
  `(loop with realt = 0
         with runt = 0
         for i from 1 upto ,iterations
         do (multiple-value-bind (result real run) (time-spent ,@body)
              (declare (ignore result))
              (incf realt real)
              (incf runt run))
         finally (format T "Iterations: ~d~%~
                            Total real time: ~f~%~
                            Total run time:  ~f~%~
                            Avg. real time:  ~f~%~
                            Avg. run time:   ~f" ,iterations realt runt (/ realt i) (/ runt i))))
