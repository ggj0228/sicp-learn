#lang sicp

(define (average a b)
  (/ (+ a b ) 2))

(define tolerance 0.00001)



(define (average-damp f)
  (lambda (x)
    (average x (f x))))

(define dx 0.00001)

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))


(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) 
            ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) 
               guess))


(define (fixed-point-of-transform 
         g transform guess)
  (fixed-point (transform g) guess))


(define (square x) (* x x))

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (compose f (repeated f (- n 1)))))

(define (halves n) (/ n 2))


(define (exp-iter b n temp)
  (cond ((= n 0) temp)
        ((even? n) (exp-iter (square b) (halves n) temp))
        (else (exp-iter b (- n 1) (* temp b)))))
(define (fast-exp b n)
  (exp-iter b n 1))

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (n-root n)
  (define damp-number (floor (log n 2)))
  (define (f x)
    (lambda (y) (/ x (fast-exp y (- n 1)))))
  (lambda (x)
    (fixed-point
     ((repeated average-damp damp-number) (f x))
     1.0)))

((n-root 2) 100)
((n-root 3) 1000)
((n-root 4) 10000)
((n-root 5) 100000)
((n-root 6) 1000000)
((n-root 7) 10000000)
((n-root 8) 100000000)
((n-root 9) 1000000000)
((n-root 10) 10000000000)