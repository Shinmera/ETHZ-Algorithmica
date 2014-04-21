
(defun find-optimal-set (limit items)
  "Find the optimal combination of items with the specified cost limit.
Each item has to be a cons with the car being the value and the cdr the cost."
  (let* ((itemcount (length items))
         (map (make-array (list (1+ itemcount) (1+ limit))
                          :initial-element 0 :element-type 'fixnum)))
    ;; build map
    (loop for i from 1 to itemcount
          for (vi . wi) in items
          do (loop for j from 1 to limit
                   do (setf (aref map i j)
                            (if (and (<= wi j)
                                     (<= (aref map (1- i) j)
                                         (+ (aref map (1- i) (- j wi)) vi)))
                                (+ (aref map (1- i) (- j wi)) vi)
                                (aref map (1- i) j)))))
    ;; backtrace
    (let ((value (aref map itemcount limit))
          (set ()))
      (loop with i = itemcount
            with j = limit
            for (vi . wi) in (reverse items)
            do (if (and (<= wi j)
                        (= (aref map i j)
                           (+ (aref map (1- i) (- j wi)) vi)))
                   (setf set (cons i set)
                         i (1- i)
                         j (- j wi))
                   (decf i)))
      (cons value set))))
