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


(define (deep-reverse items)
  (define (reverse-iter x result)
    (if (null? x)
        result
        (if (pair? (car x))
            (reverse-iter (cdr x) (cons (deep-reverse (car x)) result))
            (reverse-iter (cdr x) (cons (car x) result)))))
  (reverse-iter items nil))



(define (fringe x)
  (cond ((null? x) nil)

        ((not (pair? x)) (list  x))

        (else
         (append (fringe (car x))
                 (fringe (cdr x))))))

(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))

(define test1 (make-mobile
               (make-branch 2 6)
               (make-branch 3 4)))

test1

(define (left-branch x)
  (car x))

(define (right-branch x)
  (cdr x))

(define (branch-length x)
  (car x))

(define (branch-structure x)
  (cdr x))

(left-branch test1)
(right-branch test1)
(branch-length (left-branch test1))
(branch-structure (left-branch test1))

(define (total-weight x)
  (cond ((null? x) 0)
        ((not (pair? x)) x)
        (else (+
               (total-weight (branch-structure (left-branch x)))
               (total-weight (branch-structure (right-branch x)))))))

(total-weight test1)



(define (balanced? x)
  (define (torque branch)
  (* (branch-length branch)
     (total-weight (branch-structure branch))))
  (let ((left (left-branch x))
        (right (right-branch x)))

       (and (= (torque left)
          (torque right))

            (if (pair? (branch-structure left))
                (balanced? (branch-structure left))
                #t)

            (if (pair? (branch-structure right))
                (balanced? (branch-structure right))
                #t))))

(balanced? test1)
             






           

