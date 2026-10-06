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





(define (reverse-O-Square items)
  (let ((l (length items)))
    (define (iter n)
      (if (= n 0)
          nil
          (cons (list-ref items (- n 1))
                (iter (- n 1)))))
    (iter l)))

(define (reverse items)
  (define (iter rest result)
    (if (null? rest)
        result
        (iter (cdr rest)
              (cons (car rest) result))))
  (iter items nil))


(reverse-O-Square (list 1 4 9 16 25))
(reverse (list 1 4 9 16 25))
