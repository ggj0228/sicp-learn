#lang sicp


(define x (cons (list 1 2) (list 3 4)))

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define (print name proc)
  (display name)
  (display " => ")
  (display proc)
  (newline))

(print `length-of-x (length x))
(print `count-leaves-of-x (count-leaves x))
(print `list-x-x (list x x))
(print `length-xx (length (list x x)))
(print `count-leaves-xx (count-leaves (list x x)))

(cons 1(cons 3 (cons (list 5 7) (cons 9 nil))))
(define list-1 (list 1 3 (list 5 7) 9))
(define list-2 (list(list 7)))
(define list-3 (list 1(list 2(list 3(list 4(list 5 (list 6 7)))))))

(car (cdr (car (cdr (cdr list-1)))))
(car (car list-2))
