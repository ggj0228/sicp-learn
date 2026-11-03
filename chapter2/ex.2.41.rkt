#lang sicp

(define (enumerate-interval start end)
  (if (> start end)
      nil
      (cons start
            (enumerate-interval (+ start 1) end))))
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))
  
(define (flatmap proc sequence)
  (accumulate append nil
              (map proc sequence)))

(define (triple-pairs n)
  (flatmap
   (lambda (i)
     (flatmap
      (lambda (j)
        (map (lambda (k)
               (list i j k))
             (enumerate-interval 1(- j 1))))
      (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(define (config-triple-sum pair s)
  (= (+ (car pair)
         (cadr pair)
         (caddr pair))
      s))

(define (find-sums-pairs n s)
  (filter
   (lambda (pair)
     (config-triple-sum pair s))
   (triple-pairs n)))

(find-sums-pairs 10 6)