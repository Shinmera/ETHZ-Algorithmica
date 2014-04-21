
(defun find-common-subseq (seq1 seq2 &key (test #'eql))
  (let* ((len1 (length seq1))
         (len2 (length seq2))
         (map (make-array (list (1+ len1) (1+ len2))
                          :element-type 'fixnum :initial-element 0)))
    ;; build map
    (loop for i from 1 to len1
          do (loop for j from 1 to len2
                   do (setf (aref map i j)
                            (if (funcall test (elt seq1 (1- i)) (elt seq2 (1- j)))
                                (1+ (aref map (1- i) (1- j)))
                                (max (aref map (1- i) j)
                                     (aref map i (1- j)))))))
    (let* ((length (aref map len1 len2))
           (sequence (subseq seq1 0 length)))
      ;; backtrace
      (loop with index = length
            with i = (1- len1)
            with j = (1- len2)
            while (< 0 index)
            do (if (funcall test (elt seq1 (1- i)) (elt seq2 (1- j)))
                   (setf (elt sequence (1- index)) (elt seq1 (1- i))
                         index (1- index)
                         i (1- i)
                         j (1- j))
                   (if (= (aref map i j) (aref map (1- i) j))
                       (decf i)
                       (decf j))))
      (cons length sequence))))
