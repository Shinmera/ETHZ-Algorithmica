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
         for (result real run) = (multiple-value-list (time-spent ,@body))
         do (incf realt real)
            (incf runt run)
         maximize real into max-realt
         maximize run into max-runt
         minimize real into min-realt
         minimize run into min-runt
         finally (format T "Iterations: ~d~%~
                            -              REALTIME  RUNTIME~%~
                            Total time     ~,5f   ~,5f~%~
                            Maximal time   ~,5f   ~,5f~%~
                            Minimal time   ~,5f   ~,5f~%~
                            Average time   ~,5f   ~,5f"
                         ,iterations realt runt
                         max-realt max-runt
                         min-realt min-runt
                         (/ realt i) (/ runt i))))
