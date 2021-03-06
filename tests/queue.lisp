
(in-package :serapeum.tests)

(def-suite queue :in serapeum)
(in-suite queue)

(test qappend
  (let* ((list (list 1 2 3))
         (queue (qappend (queue) list))
         (qlist (qlist queue)))
    (is (not (eq qlist list)))))

(test qconc
  (let* ((list (list 1 2 3))
         (queue (qconc (queue) list))
         (qlist (qlist queue)))
    (is (eq qlist list))
    (let ((queue2 (qconc queue nil)))
      (is (eq qlist list))
      (is (eq queue queue2)))))

(test undeq
  (flet ((q= (q1 q2)
           (equal (qlist q1)
                  (qlist q2))))
    (let ((q1 (queue))
          (q2 (queue)))
      (enq 1 q1)
      (undeq 1 q2)
      (is (q= q1 q2)))
    (let ((q1 (queue 1))
          (q2 (queue 2)))
      (enq 2 q1)
      (undeq 1 q2)
      (is (q= q1 q2)))
    (for-all ((len (gen-integer :max 10 :min 1)))
      (let* ((nums (range len))
             (q (multiple-value-call #'queue
                  (values-vector nums))))
        (is (q= q
                (let ((item (deq q)))
                  (undeq item q)
                  q)))))))

(test setf-front
  (let ((q (queue)))
    (is (null (front q)))
    (setf (front q) 1)
    (is (equal 1 (front q)))
    (is (equal '(1) (qlist q))))
  (let ((q (queue 2 2)))
    (setf (front q) 1)
    (is (eql (front q) 1))
    (is (equal '(1 2) (qlist q)))))

(test qback
  (let ((q (queue)))
    (is (null (qback q)))
    (enq 1 q)
    (is (eql 1 (qback q))))
  (let ((q (queue 1)))
    (is (eql 1 (qback q)))
    (is (equal '(1) (qlist q)))))

(test setf-qback
  (let ((q (queue)))
    (is (null (qback q)))
    (setf (qback q) 1)
    (is (eql 1 (qback q)))
    (is (equal '(1) (qlist q))))
  (let ((q (queue 1)))
    (is (eql 1 (qback q)))
    (setf (qback q) 2)
    (is (eql 2 (qback q)))
    (is (equal '(2) (qlist q))))
  (let ((q (queue 1 2)))
    (is (eql 2 (qback q)))
    (setf (qback q) 3)
    (is (eql 3 (qback q)))
    (is (equal '(1 3) (qlist q)))))
