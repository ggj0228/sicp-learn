#lang sicp


(define (square x) (* x x))


(define (square-tree tree)
  (cond ((null? tree)nil)
        ((pair? tree)
         (cons (square-tree (car tree))
               (square-tree (cdr tree))))
        (else  (square tree))))
       


         
(define(square-tree-by-map tree)
  (map (lambda (sub-tree)
         (if (not (pair? sub-tree))
             (square sub-tree)
             (square-tree sub-tree)))
       tree)
  )

(square-tree (list 1 (list 2 3) 4 (list 5 6)))
(square-tree-by-map (list 1 (list 2 3) 4 (list 5 6)))

