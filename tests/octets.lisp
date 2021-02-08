(in-package :serapeum.tests)

(def-suite octets :in serapeum)
(in-suite octets)

;; This appears to fail on negative numbers
;; (test unoctets
;;   (for-all ((n (a-fixnum)))
;;     (is (= (unoctets (octets n)) n))))

(test octet-vector-p
  (with-notinline (octet-vector-p)
    (is (octet-vector-p (make-octet-vector 1)))
    (is (not (octet-vector-p "x")))))

(test octet-vector
  (with-notinline (octet-vector)
    (let ((ov (octet-vector 1 5 18)))
      (is (octet-vector-p ov))
      (is (eql 1 (elt ov 0)))
      (is (eql 5 (elt ov 1)))
      (is (eql 18 (elt ov 2)))
      (is (eql 3 (length ov))))))

(test octets
  (is (equalp #() (octets 0)))
  (is (equalp #(1) (octets 1)))
  (is (equalp #(255) (octets 255)))
  (is (equalp #(0 1) (octets 256)))
  (is (equalp #(1 0) (octets 256 :big-endian t))))

(test octets-unoctets
  (is (null (loop for i from 0 to #x10000
                  for o = (octets i)
                  for u = (unoctets o)
                  unless (eql i u)
                    collect (list i o u))))
  (is (null (loop for i from 0 to #x10000
                  for o = (octets i :big-endian t)
                  for u = (unoctets o :big-endian t)
                  unless (eql i u)
                    collect (list i o u)))))
