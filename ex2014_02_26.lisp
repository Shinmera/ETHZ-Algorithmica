(declaim (optimize (speed 3) (safety 0) (debug 0))
         (inline s-linear s-quad s-double new-array-map 0-bound)
         (ftype (function ((unsigned-byte 5) (unsigned-byte 5) (unsigned-byte 5)) (signed-byte 6)) s-linear s-quad s-double)
         (ftype (function ((signed-byte 6)) (unsigned-byte 5)) 0-bound)
         (ftype (function (function (unsigned-byte 5)) cons) new-array-map)
         (ftype (function (cons (unsigned-byte 5)) (unsigned-byte 5)) insert)
         (ftype (function () null) run-public))

(defun s-linear (j k m)
  (declare (ignore k m))
  j)

(defun s-quad (j k m)
  (declare (ignore k m))
  (* (expt (ceiling (/ j 2)) 2) (expt -1 j)))

(defun s-double (j k m)
  (* j (+ 1 (mod k (- m 2)))))

(defun new-array-map (mitigation-function size)
  (cons (make-array size :element-type '(unsigned-byte 5))
        mitigation-function))

(defun 0-bound (index)
  ;; We have to min-bind it for s-quad since otherwise we get impossible values.
  ;; Good job to whatever idiot wrote this shitty exercice.  
  (if (< index 0) 0 index))

(defun insert (map element)
  (loop with size of-type (unsigned-byte 5) = (array-dimension (car map) 0)
        with init-pos of-type (unsigned-byte 5) = (mod element size)
        for j of-type (unsigned-byte 5) from 0
        for pos of-type (unsigned-byte 5) = init-pos
          then (0-bound (mod (- init-pos (funcall (cdr map) j element size)) size))
        until (zerop (aref (car map) pos))
        finally (progn
                  (setf (aref (car map) pos) element)
                  (return j))))

(defmacro test-table (function line)
  `(let ((table (new-array-map ,function ,(first line))))
     (cons (+ ,@(loop for item in (cddr line)
                        collect `(insert table ,item)))
           (car table))))

(defmacro exercise2 (data)
  `(progn
    ,@(loop for line in data
            collect `(progn (test-table #'s-linear ,line)
                           (test-table #'s-quad ,line)
                           (test-table #'s-double ,line)))))

(defun run-public ()
  (exercise2 ((5 3 4 5 4)
              (7 4 3 4 7 3)
              (7 5 10 7 3 10 6)
              (13 9 12 11 10 6 9 3 14 4 16)
              (13 8 8 10 6 8 8 9 8 3)
              (19 12 18 13 14 24 12 17 4 4 21 2 16 6)
              (19 13 15 21 16 12 7 4 22 9 5 18 6 9 10)))
  NIL)
