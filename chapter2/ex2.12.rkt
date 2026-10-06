#lang sicp

(define (make-interval a b) (cons a b))

(define (lower-bound x) (car x))
(define (upper-bound x) (cdr x))



(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) 
        (upper-bound i)) 
     2))

(define (width i)
  (/ (- (upper-bound i) 
        (lower-bound i)) 
     2))


(define (percent p)
  (let ((c (center p))
        (w (width p)))
    (* (/ w c) 100)))


(define (make-center-percent c p)
  (let ((w (* c p 0.01)))
    (make-interval (- c w) (+ c w))))


(define P (make-center-percent 6.8 10))

(display P)
(newline)
(width P)
(center P)
(percent P)
    
  