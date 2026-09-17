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

(define (iterative-improve goodenough? improve)
  (define (iter guess)
    (let ((next (improve guess)))
      (if (goodenough? next)
          next
          (iter next))))
  (iter 1.0))

(define (good? n)
  (lambda (x)
    (< (abs (- (* x x) n)) 0.00001)))

(define (improve n)
  (lambda (x)
    (/ (+ x (/ n x)) 2)))

(define (sqrt n)
  (iterative-improve (good? n) (improve n)))

(define (fixed-good? f)
  (lambda (x)
    (< (abs (- (f x) x)) tolerance)))

(define (fixed-improve f)
  (lambda (x)
    (f x)))

(define (iterative-fixed-point f)
  (iterative-improve (fixed-good? f) (fixed-improve f)))

(sqrt 4)

(iterative-fixed-point
 (lambda (x)
   (average x (/ 2 x))))


