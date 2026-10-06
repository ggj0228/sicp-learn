#lang sicp




(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(map (lambda (x) (* x x) ) (list 1 2 3 4))

(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))

(define (square-list items)
  (if (null? items)
      nil
      (cons (* (car items) (car items))
            (square-list (cdr items)))))

(square-list (list 1 2 3 4))

(define (square x) (* x x ))
(define (square-list2 items)
  (map square items))

(square-list2 (list 1 2 3 4))