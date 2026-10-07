#lang sicp

(define (square x) (* x x))


(for-each 
 (lambda (x) (newline) (display x))
 (list 57 321 88))


(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (each proc items)
  (if (null? items)
      (newline)
      (and (proc (car items))
           (each proc (cdr items)))))


(define (e proc items)
  (map proc items))

(e
 (lambda (x) (newline) (display x))
 (list 57 321 88))