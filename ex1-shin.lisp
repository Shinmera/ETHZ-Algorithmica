;; Optimize the hell out of everything
(declaim (optimize (speed 3) (safety 0) (debug 0)))
;; Actual algorithm using declared types
(defun R2 (i a b c d)
  (case i
    (0 a) (1 b)
    (T (loop for n of-type (signed-byte 45) from 1 below i
             for z2 of-type (signed-byte 45) = a then z1
             for z1 of-type (signed-byte 45) = b then z
             for z of-type (signed-byte 45) = (the (signed-byte 45) (+ (the (signed-byte 45) (* z1 c))
                                                                       (the (signed-byte 45) (* z2 d))))
             finally (return z)))))
;; Declare function arguments and return values. We can use a signed-byte 45 here as that's the smallest container
;; that fits the largest output value (11508564309136) in this exercise.
(declaim (ftype (function ((unsigned-byte 6) (signed-byte 11) (signed-byte 11) (signed-byte 2) (signed-byte 2)) (signed-byte 45)) R2))
;; Inline the function for some more extra speed
(declaim (inline R2))
;; This can be a macro so we expand directly into function calls without wasting time.
(defmacro exercise1 (data)
  `(progn ,@(mapcar #'(lambda (line) `(R2 ,@line)) data)))
;; Define a function wrapper to run the test
(defun run-hard ()
  (exercise1 ((24 831 392 -1 -1)
              (1 453 -247 1 1)
              (16 884 -980 1 -1)
              (43 -799 -778 1 1)
              (6 -18 300 1 -1)
              (35 127 -57 1 1)
              (48 825 705 -1 -1)
              (11 -103 -955 1 -1)
              (16 692 -761 -1 -1)
              (31 884 -279 -1 1)
              (43 226 -717 1 -1)
              (34 -367 -915 -1 -1)
              (36 -506 -313 -1 1)
              (23 436 -302 -1 -1)
              (49 699 673 1 -1)
              (15 855 -780 1 -1)
              (30 -46 -623 -1 -1)
              (26 -642 -122 1 1)
              (22 828 915 -1 -1)
              (20 615 627 -1 1)
              (40 -469 428 1 1)
              (33 151 -748 1 1)
              (2 -100 262 -1 -1)
              (18 223 537 1 -1)
              (10 -90 -47 1 -1)
              (2 496 -142 1 -1)
              (33 744 -578 -1 1)
              (17 -983 -584 1 -1)
              (31 -587 155 -1 -1)
              (18 656 376 -1 1)
              (18 294 -646 -1 -1)
              (26 924 -825 1 1)
              (9 -903 -509 1 1)
              (25 866 -308 -1 1)
              (10 466 203 1 -1)
              (39 622 393 1 1)
              (35 750 -264 1 -1)
              (8 960 770 -1 1)
              (24 -271 -621 -1 1)
              (40 -367 -884 1 -1)
              (1 -777 -6 -1 1)
              (43 623 -608 -1 1)
              (46 55 -67 1 1)
              (42 -327 690 -1 1)
              (3 753 539 1 1)
              (23 -905 648 1 1)
              (4 591 357 1 -1)
              (49 -402 -854 -1 -1)
              (33 -602 202 1 -1)
              (35 127 -383 1 1)
              (50 664 504 1 1)
              (37 62 190 1 1)
              (11 -682 357 -1 -1)
              (39 747 48 1 1)
              (18 459 -388 -1 1)
              (1 427 870 1 -1)
              (23 -872 932 1 1)
              (48 -403 125 1 -1)
              (27 45 -932 -1 -1)
              (48 658 31 -1 -1)
              (43 -838 -732 -1 -1)
              (9 -808 612 1 1)
              (7 412 -146 1 -1)
              (44 -451 595 1 -1)
              (29 -898 309 -1 -1)
              (42 955 250 -1 1)
              (21 996 506 1 1)
              (28 -287 -100 1 1)
              (24 601 -828 -1 1)
              (13 156 -237 -1 -1)
              (23 426 -971 1 1)
              (24 -643 927 1 -1)
              (33 -727 858 1 -1)
              (17 -368 -886 1 1)
              (18 -412 -674 -1 -1)
              (8 -804 153 1 1)
              (9 79 277 -1 1)
              (6 -358 -194 -1 1)
              (18 -96 440 1 1)
              (2 106 -394 -1 1)
              (3 -595 972 -1 -1)
              (39 -587 -23 -1 -1)
              (32 -862 941 1 1)
              (48 -791 215 -1 1)
              (31 553 908 1 1)
              (30 -779 -219 1 -1)
              (35 -297 170 1 -1)
              (1 418 923 1 1)
              (3 -973 -414 -1 -1)
              (36 -520 532 1 -1)
              (17 386 -149 -1 -1)
              (35 205 -102 1 1)
              (1 -531 812 -1 1)
              (24 931 -370 1 1)
              (27 428 768 1 1)
              (21 718 -131 1 -1)
              (20 -137 -188 1 -1)
              (21 725 -954 1 -1)
              (25 510 -798 -1 1)
              (14 903 799 -1 1))))
(declaim (inline run-hard))
;; And finally, run the test
;; (with-timing 1000000 (run-hard))

