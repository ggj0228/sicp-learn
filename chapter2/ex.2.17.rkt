#lang sicp

(define (length x)
  (if (null? x)
      0
      (+ 1 (length (cdr x)))))

(define lll
  (list 1 2 3 4 5))

(length lll)

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items)
                (- n 1))))

(define (last-pair items)
  (let ((l (length items)))
    (list-ref items (- l 1))))

(last-pair (list 23 72 149 34))
