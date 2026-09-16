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

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))
(define dx 0.00001)


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
(define (double f)
  (lambda (x) (f (f x))))


(((double (double double)) inc) 5)


#|
(double double) means f -> f(f(f(f x))).

If we simply define (double double) as 4x,
then the next process becomes:

((4x (4x inc)) 5)

The inner (4x inc) creates a procedure that applies inc 4 times.
Then the outer 4x repeats that whole procedure 4 times.

So inc is applied 4 * 4 = 16 times,
and the result is 21, not 13.

Keep in mind that (double double) is a new procedure
that repeats another procedure 4 times.
|#
