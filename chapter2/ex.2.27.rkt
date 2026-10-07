#lang sicp

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


(define x 
  (list (list 1 2) (list 3 4)))

(reverse x)

(define (deep-reverse items)
  (define (reverse-iter x result)
    (if (null? x)
        result
        (if (pair? (car x))
            (reverse-iter (cdr x) (cons (deep-reverse (car x)) result))
            (reverse-iter (cdr x) (cons (car x) result)))))
  (reverse-iter items nil))

(deep-reverse x)
  