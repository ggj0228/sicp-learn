# SICP Chapter 1 — Building Abstractions with Procedures

SICP 1장은 Scheme 문법 자체보다 **계산 과정을 이해하고, 반복되는 구조를 프로시저로 추상화하는 방법**을 다룬다.

---

## 1. Procedure와 Process

프로시저는 계산 방법을 기술한 코드이고, 프로세스는 그 프로시저가 실제 실행되면서 만들어내는 계산 과정이다.

같은 문제라도 계산 과정은 다를 수 있다.

### Recursive Process

```scheme
(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))
```

계산이 먼저 확장되고 이후 축소된다.

### Iterative Process

```scheme
(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))
```

현재 상태만 유지하면서 다음 상태로 이동한다.

즉 **재귀적으로 작성된 프로시저와 recursive process는 같은 개념이 아니다.**

---

## 2. 계산 과정의 효율성

알고리즘에서는 정답뿐 아니라 입력이 커질 때 계산량이 어떻게 증가하는지도 중요하다.

예를 들어 단순한 거듭제곱은

$$
\Theta(n)
$$

이지만,

$$
b^n = \left(b^{n/2}\right)^2
$$

라는 성질을 이용하면

$$
\Theta(\log n)
$$

으로 줄일 수 있다.

GCD 역시

$$
a = qb + r
$$

일 때

$$
\gcd(a,b)=\gcd(b,r)
$$

이라는 관계를 이용한다.

여기서 중요한 점은 **수학적 관계를 발견하면 계산 과정 자체를 바꿀 수 있다는 것**이다.

---

## 3. Higher-Order Procedures

Chapter 1 후반부에서는 프로시저를 값처럼 다룬다.

프로시저를

* 인자로 전달하고
* 다른 프로시저 안에서 실행하고
* 새로운 프로시저로 반환할 수 있다.

예를 들어 여러 합 계산에서 반복되는 구조를 `sum`으로 추상화한다.

```scheme
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
```

여기서 달라지는 부분인 `term`, `next`를 밖에서 전달한다.

더 일반화하면

```scheme
(accumulate combiner null-value term a next b)
```

와 같이 결합 방법까지 추상화할 수 있다.

즉

```text
sum-integers
sum-cubes
product
integral
      ↓
     sum
      ↓
 accumulate
```

처럼 구체적인 문제에서 공통 구조를 뽑아낸다.

---

## 4. Fixed Point와 Average Damping

Fixed point는

$$
f(x)=x
$$

를 만족하는 $x$이다.

제곱근 문제

$$
y^2=x
$$

를 변형하면

$$
y=\frac{x}{y}
$$

가 된다.

하지만

$$
y \rightarrow \frac{x}{y}
$$

를 그대로 반복하면 두 값 사이에서 진동한다.

그래서 average damping을 적용한다.

$$
y
\rightarrow
\frac{y+x/y}{2}
$$

Scheme에서는

```scheme
(fixed-point
 (average-damp
  (lambda (y) (/ x y)))
 1.0)
```

처럼 표현할 수 있다.

처음에는 특별한 제곱근 공식처럼 보였던 것이 사실

```text
fixed-point
+
average-damp
```

라는 일반적인 개념의 조합이었다.

---

## 5. Newton's Method

Newton's Method는

$$
g(x)=0
$$

의 근을 찾기 위해

$$
x
\rightarrow
x-\frac{g(x)}{g'(x)}
$$

라는 변환을 반복한다.

SICP에서는 이를 다시 fixed point로 표현한다.

```scheme
(define (newtons-method g guess)
  (fixed-point
   (newton-transform g)
   guess))
```

즉 Newton's Method 역시

```text
newton-transform
+
fixed-point
```

라는 조합으로 볼 수 있다.

---

## 6. Chapter 1에서 가져갈 것

Chapter 1에서 중요한 것은 개별 알고리즘을 모두 외우는 것이 아니다.

전체 흐름은 다음과 같다.

```text
구체적인 문제를 해결한다
        ↓
계산 과정을 관찰한다
        ↓
반복되는 구조를 발견한다
        ↓
변하는 부분을 분리한다
        ↓
프로시저로 추상화한다
        ↓
추상화를 다시 조합한다
```

예를 들어

```text
sum-cubes → sum → accumulate
sqrt → fixed-point + average-damp
Newton's Method → fixed-point + newton-transform
```

처럼 점점 더 일반적인 개념으로 올라간다.

결국 Chapter 1의 핵심은 **문제마다 코드를 새로 작성하는 것이 아니라, 계산에서 반복되는 구조를 발견하고 그것을 새로운 추상화로 만드는 것**이라고 생각한다.
