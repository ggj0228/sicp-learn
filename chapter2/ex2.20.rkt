#lang sicp



(define (same-parity . w)
  (define (iter items parity)
    (cond ((null? items)
           nil)
          ((= (remainder (car items) 2) parity)
           (cons (car items)
                 (iter (cdr items) parity)))
          (else (iter (cdr items) parity))))
  (iter w (remainder (car w) 2)))


(same-parity 1 2 3 4 5 6 7)

(same-parity 2 3 4 5 6 7)
