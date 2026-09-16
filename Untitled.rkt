#lang sicp


(define (square n)
  (* n n))

(define (divides? a b)
  (= (remainder b a) 0))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (prime? n)
  (= (smallest-divisor n) n))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))


(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))


(define (search-for-primes n count)
  (cond ((= count 0)
         'done)
        ((prime? n)
         (timed-prime-test n)
         (search-for-primes (+ n 2) (- count 1)))
        (else
         (search-for-primes (+ n 2) count))))



