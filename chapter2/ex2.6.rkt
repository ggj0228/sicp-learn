#lang sicp

(define zero
  (lambda (f)
    (lambda (x) x)))


(define (successor n)
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))

(define one (successor zero))

(define two (successor one))

(define (to-int n)
  ((n inc) 0))

(define (+ a b)
  (lambda (f)
    (lambda (g)
      ((a f) ((b f) g)))))


(to-int one)
(to-int two)

(define three
   (+ one two))

(to-int three)