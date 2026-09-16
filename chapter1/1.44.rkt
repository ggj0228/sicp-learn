#lang sicp

(define (average a b)
  (/ (+ a b ) 2))

(define tolerance 0.00001)


(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (average-damp f x)
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

(define (smooth f)
  (lambda (x) (/
               (+
                (f (- x dx))
                (f x)
                (f (+ x dx)))
               3
               )))

(define (smooth-n f n)
  ((repeated smooth n) f))

(((repeated smooth 2) square) 5)
((smooth-n  square 2) 5)

        
