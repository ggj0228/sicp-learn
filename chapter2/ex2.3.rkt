#lang sicp

(define (make-rat n d)
  (cons n d))
(define (numer x)
  (let ((g (gcd (car x) (cdr x))))
    (/ (car x) g)))

(define (denom x)
  (let ((g (gcd (car x) (cdr x))))
    (/ (cdr x) g)))

(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define (make-point x y)
  (cons x y))

(define (x-point x)
  (car x))

(define (y-point y)
  (cdr y))

(define (make-segment a b)
  (cons a b))

(define (start-segment x)
  (car x))
(define (end-segment x)
  (cdr x))

(define (mid-point p1 p2)
  (let ((x (/ (+ (x-point p1) (x-point p2)) 2))
        (y (/ (+ (y-point p1) (y-point p2)) 2)))
  (make-point x y)))

(define (midpoint-segment x)
  (mid-point (start-segment x) (end-segment x)))


(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))


(define (make-rectangle p width height)
  (cons p (cons width height)))

(define (rectangle-width r)
  (car (cdr r)))
(define (rectangle-height r)
  (cdr (cdr r)))


(define (rectangle-area r)
  (* (rectangle-width r)
     (rectangle-height r)))

(define (rectangle-perimeter r)
  (* 2
     (+ (rectangle-width r)
        (rectangle-height r))))

(define p1 (make-point 1 1))
(define p2 (make-point 5 4))

(define rect
  (make-rectangle (make-point 1 1) 4 3))

(rectangle-area rect)
(rectangle-perimeter rect)






