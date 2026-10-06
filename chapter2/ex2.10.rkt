#lang sicp

(define (make-interval a b) (cons a b))

(define (upper-bound x) (cdr x))
(define (lower-bound y) (car y))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) 
                    (lower-bound y))
                 (+ (upper-bound x) 
                    (upper-bound y))))
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) 
               (lower-bound y)))
        (p2 (* (lower-bound x) 
               (upper-bound y)))
        (p3 (* (upper-bound x) 
               (lower-bound y)))
        (p4 (* (upper-bound x) 
               (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))


(define (pos? x)
  (or (= x 0) (> x 0)))
(define (neg? x)
  (< x 0))

(define (contain-zero? n)
  (cond ((and (neg? (lower-bound n))
              (pos? (upper-bound n)))
         #t)
        ((and (= (lower-bound n) 0)
              (= (upper-bound n) 0))
         #t)
        (else #f)))

(define (div-interval x y)
  (if (contain-zero? y)
      (error "second argument contains zero in range"))
  (mul-interval x
                (make-interval
                   (/ 1.0 (upper-bound y))
                   (/ 1.0 (lower-bound y)))))
          

(define p1 (make-interval 2.3 2.5))
(define p2 (make-interval 1.0 1.0))

(div-interval p1 p2)


