#lang sicp



#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (filter predicate items)
  (cond ((null? items) nil)
        ((predicate (car items))
         (cons (car items)
               (filter predicate (cdr items))))
        (else (filter predicate (cdr items)))))

(define (flatmap proc sequence)
  (accumulate append nil (map proc sequence)))

(define (enumerate-interval start end)
  (if (> start end)
      nil
      (cons start
            (enumerate-interval (+ start 1) end))))

(define (adjoin-position which-row which-k sets)
  (append sets (list (list which-row which-k))))

(define empty-board nil)

(define (conflict? q1 q2)
  (let ((r1 (car q1))
        (c1 (cadr q1))
        (r2 (car q2))
        (c2 (cadr q2)))
    (or (= r1 r2)
        (= c1 c2)
        (= (abs (- r1 r2))
           (abs (- c1 c2))))))

(define (safe? k positions)
  (let ((reversed (reverse positions)))
    (let ((new-queen (car reversed))
          (others (cdr reversed)))

      (define (check others)
        (cond ((null? others) #t)
              ((conflict? new-queen (car others)) #f)
              (else (check (cdr others)))))

      (check others))))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions)
           (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position
                    new-row
                    k
                    rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(queens 4)





















