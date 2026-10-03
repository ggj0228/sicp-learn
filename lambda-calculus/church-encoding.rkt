
#lang sicp

;; ==========================================
;; 공통 테스트 출력 함수
;; ==========================================

(define (section title)
  (newline)
  (display "========================================")
  (newline)
  (display title)
  (newline)
  (display "========================================")
  (newline))

(define (test label result)
  (display label)
  (display " => ")
  (display result)
  (newline))


;; ==========================================
;; 1. 논리값 T, F
;; ==========================================

(define lt
  (lambda (x)
    (lambda (y)
      x)))

(define lf
  (lambda (x)
    (lambda (y)
      y)))

;; 논리값을 문자열로 변환
(define (bool->string b)
  ((b "TRUE") "FALSE"))


;; [TEST 1]
(section "1. Boolean")

(test "lt(10, 20)"
      ((lt 10) 20))

(test "lf(10, 20)"
      ((lf 10) 20))

(test "lt"
      (bool->string lt))

(test "lf"
      (bool->string lf))


;; ==========================================
;; 2. 처치 수
;; ==========================================

(define zero
  (lambda (s)
    (lambda (z)
      z)))

;; 처치 수 -> 일반 정수 변환
(define (to-int n)
  ((n inc) 0))


;; [TEST 2-1]
(section "2-1. Church Numeral ZERO")

(test "ZERO"
      (to-int zero))

;; 함수를 0번 적용
(test "ZERO: double(3)"
      ((zero (lambda (x) (* x 2))) 3))


;; ==========================================
;; 3. 계승자 SUCCESSOR
;; ==========================================

(define (successor n)
  (lambda (s)
    (lambda (z)
      (s ((n s) z)))))


(define one (successor zero))
(define two (successor one))
(define three (successor two))
(define four (successor three))


;; [TEST 3]
(section "3. Successor & Church Numerals")

(test "ZERO"
      (to-int zero))

(test "ONE"
      (to-int one))

(test "TWO"
      (to-int two))

(test "THREE"
      (to-int three))

(test "FOUR"
      (to-int four))

(test "Successor ZERO"
      (to-int (successor zero)))

(test "Successor THREE"
      (to-int (successor three)))

;; 반복 적용 확인
(test "TWO: double(3)"
      ((two (lambda (x) (* x 2))) 3))

(test "THREE: double(3)"
      ((three (lambda (x) (* x 2))) 3))


;; ==========================================
;; 4. ISZERO
;; ==========================================

(define (iszero n)
  ((n (lambda (x) lf)) lt))


;; [TEST 4]
(section "4. ISZERO")

(test "ISZERO ZERO"
      (bool->string (iszero zero)))

(test "ISZERO ONE"
      (bool->string (iszero one)))

(test "ISZERO TWO"
      (bool->string (iszero two)))

(test "ISZERO THREE"
      (bool->string (iszero three)))


;; ==========================================
;; 5. 쌍 PAIR
;; ==========================================

(define (pair a b)
  (lambda (z)
    ((z a) b)))

(define (first p)
  (p lt))

(define (second p)
  (p lf))


;; [TEST 5]
(section "5. PAIR")

(define p1 (pair two three))

(test "PAIR(2,3) FIRST"
      (to-int (first p1)))

(test "PAIR(2,3) SECOND"
      (to-int (second p1)))


(define p2 (pair zero four))

(test "PAIR(0,4) FIRST"
      (to-int (first p2)))

(test "PAIR(0,4) SECOND"
      (to-int (second p2)))


;; ==========================================
;; 6. PHI
;; Phi(a,b) = (a+1,a)
;; ==========================================

(define (phi p)
  (pair
   (successor (first p))
   (first p)))


;; [TEST 6]
(section "6. PHI")

;; Phi(2,1) = (3,2)
(define p3 (phi (pair two one)))

(test "PHI(2,1) FIRST"
      (to-int (first p3)))

(test "PHI(2,1) SECOND"
      (to-int (second p3)))


;; Phi(0,0) = (1,0)
(define p4 (phi (pair zero zero)))

(test "PHI(0,0) FIRST"
      (to-int (first p4)))

(test "PHI(0,0) SECOND"
      (to-int (second p4)))


;; ==========================================
;; 7. 선행자 PREDECESSOR
;; ==========================================

(define (pred n)
  (second
   ((n phi) (pair zero zero))))


;; [TEST 7]
(section "7. PREDECESSOR")

(test "PRED ZERO"
      (to-int (pred zero)))

(test "PRED ONE"
      (to-int (pred one)))

(test "PRED TWO"
      (to-int (pred two)))

(test "PRED THREE"
      (to-int (pred three)))

(test "PRED FOUR"
      (to-int (pred four)))


;; ==========================================
;; 8. Z 조합자
;; Applicative Order용 재귀 연산자
;; ==========================================

(define Z
  (lambda (f)
    ((lambda (x)
       (f (lambda (v)
            ((x x) v))))
     (lambda (x)
       (f (lambda (v)
            ((x x) v)))))))


;; [TEST 8]
(section "8. Z COMBINATOR")

;; 재귀 인자를 받지만 사용하지 않는 함수
(define constant-two
  (lambda (r)
    (lambda (n)
      two)))

(test "Z CONSTANT-TWO (ZERO)"
      (to-int ((Z constant-two) zero)))

(test "Z CONSTANT-TWO (THREE)"
      (to-int ((Z constant-two) three)))


;; ==========================================
;; 9. 재귀 함수 R
;;
;; R(r)(n)
;; n = 0 -> 0
;; n > 0 -> n + r(n-1)
;; ==========================================

(define R
  (lambda (r)
    (lambda (n)
      (if (= (((iszero n) 1) 0) 1)
          zero
          ((n successor)
           (r (pred n)))))))


;; [TEST 9]
(section "9. RECURSIVE FUNCTION R")

;; 재귀에 사용할 함수를 직접 전달
;; 여기서는 어떤 입력이든 ZERO를 반환
(define R-test
  (R (lambda (n) zero)))

(test "R-test ZERO"
      (to-int (R-test zero)))

(test "R-test ONE"
      (to-int (R-test one)))

(test "R-test TWO"
      (to-int (R-test two)))

(test "R-test THREE"
      (to-int (R-test three)))


;; ==========================================
;; 10. 재귀 함수 생성
;; SUM(n) = n + SUM(n-1)
;; ==========================================

(define sum-n (Z R))


;; [TEST 10]
(section "10. RECURSIVE SUM")

(test "SUM ZERO"
      (to-int (sum-n zero)))

(test "SUM ONE"
      (to-int (sum-n one)))

(test "SUM TWO"
      (to-int (sum-n two)))

(test "SUM THREE"
      (to-int (sum-n three)))

(test "SUM FOUR"
      (to-int (sum-n four)))
