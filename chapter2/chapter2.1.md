# SICP Chapter 2.1 — Introduction to Data Abstraction

SICP 2.1장은 Chapter 1에서 배운 **추상화의 대상을 프로시저에서 데이터로 확장**한다.

Chapter 1에서는 반복되는 계산 구조를 프로시저로 묶었다면, Chapter 2.1에서는 복잡한 데이터를 직접 다루지 않고 **constructor와 selector를 통해 추상적인 대상으로 다루는 방법**을 배운다.

핵심 질문은 다음과 같다.

> 데이터를 사용하는 코드가 데이터의 내부 표현까지 알아야 하는가?

SICP의 답은 아니다.

데이터를 사용하는 부분과 데이터를 표현하는 부분 사이에 **추상화 장벽(abstraction barrier)**을 두어 서로 독립적으로 변경할 수 있도록 하는 것이 핵심이다.

---

## 1. Data Abstraction

유리수를 프로그램에서 표현한다고 생각해보자.

유리수는 분자와 분모를 가지므로 pair를 이용해 구현할 수 있다.

```scheme
(define (make-rat n d)
  (cons n d))

(define (numer x)
  (car x))

(define (denom x)
  (cdr x))
```

하지만 유리수를 사용하는 프로시저는 내부적으로 `cons`, `car`, `cdr`를 사용한다는 사실을 알 필요가 없다.

예를 들어 덧셈은

```scheme
(define (add-rat x y)
  (make-rat
   (+ (* (numer x) (denom y))
      (* (numer y) (denom x)))
   (* (denom x) (denom y))))
```

처럼 작성할 수 있다.

여기서 중요한 것은 `add-rat`이 pair를 직접 조작하지 않는다는 점이다.

```text
유리수 연산
add-rat / sub-rat / mul-rat / div-rat
                  ↓
        numer / denom / make-rat
                  ↓
             실제 표현
             cons / car / cdr
```

각 계층은 바로 아래 계층의 인터페이스만 알고 있다.

이러한 구조를 **abstraction barrier**라고 한다.

---

## 2. Constructor와 Selector

추상 데이터를 다룰 때 기본적으로 두 종류의 프로시저가 사용된다.

### Constructor

데이터를 생성한다.

```scheme
(make-rat n d)
(make-interval lower upper)
```

### Selector

데이터 내부의 필요한 정보를 가져온다.

```scheme
(numer x)
(denom x)

(lower-bound x)
(upper-bound x)
```

중요한 것은 이 프로시저들이 어떻게 구현되어 있는가보다 **어떤 관계를 만족해야 하는가**이다.

예를 들어 pair라면

```text
(car (cons a b)) = a

(cdr (cons a b)) = b
```

라는 관계가 중요하다.

즉 데이터의 의미를

```text
메모리에 어떻게 저장되어 있는가
```

보다

```text
어떤 연산을 제공하며
그 연산 사이에 어떤 관계가 성립하는가
```

를 통해 정의할 수 있다.

---

## 3. Abstraction Barrier

추상화 장벽의 목적은 단순히 코드를 예쁘게 만드는 것이 아니다.

내부 표현과 그것을 사용하는 코드를 분리하면 **한쪽의 변경이 다른 쪽으로 퍼지는 것을 막을 수 있다.**

예를 들어 처음에는

```scheme
(make-rat n d)
```

가 단순히

```scheme
(cons n d)
```

를 만들었다고 하자.

나중에는 유리수를 생성할 때 최대공약수로 약분하도록 바꿀 수 있다.

```scheme
(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g)
          (/ d g))))
```

하지만 `add-rat`, `mul-rat` 같은 코드는 수정할 필요가 없다.

그 코드들은 애초에 내부 표현이 아니라

```scheme
make-rat
numer
denom
```

에만 의존하고 있기 때문이다.

즉 추상화 장벽은

```text
변경이 일어나는 영역을 제한한다.
```

는 의미도 가진다.

---

## 4. Representation Independence

하나의 추상 데이터는 반드시 하나의 방식으로만 표현되어야 하는 것이 아니다.

예를 들어 pair `(a, b)`를 Scheme의 기본 pair 대신 프로시저로 표현할 수도 있다.

```scheme
(define (cons a b)
  (lambda (m)
    (m a b)))
```

그리고

```scheme
(define (car z)
  (z (lambda (a b) a)))

(define (cdr z)
  (z (lambda (a b) b)))
```

라고 정의할 수 있다.

예를 들어

```scheme
(car (cons 3 4))
```

를 계산하면

```scheme
((lambda (m)
   (m 3 4))
 (lambda (a b) a))
```

가 되고,

```scheme
((lambda (a b) a) 3 4)
```

가 되어 결국

```text
3
```

을 얻는다.

즉 Scheme의 기본 pair와 전혀 다른 내부 표현이지만

```text
cons
car
cdr
```

가 동일한 관계를 만족하기 때문에 외부에서는 같은 pair로 사용할 수 있다.

---

## 5. What Is Data?

이 부분에서 데이터에 대한 관점을 더 확장한다.

pair `(a, b)`는 procedure뿐 아니라 하나의 integer로도 표현할 수 있다.

두 자연수 `(a, b)`를

$$
2^a3^b
$$

로 나타낸다.

예를 들어

$$
(2,3)
$$

은

$$
2^2 \times 3^3 = 108
$$

이 된다.

108에서 2와 3의 지수를 다시 구하면

```text
a = 2
b = 3
```

을 복원할 수 있다.

즉 같은 pair라는 추상 데이터를

```text
Scheme pair
procedure
integer
```

처럼 전혀 다른 방식으로 표현할 수 있다.

여기서 중요한 것은 **추상 데이터의 의미가 특정한 내부 표현에 있는 것이 아니라, 그 데이터에 대해 제공되는 연산과 그 연산들이 만족하는 관계에 있다는 점**이다.

---

## 6. Church Numerals

이 생각을 더 밀어붙이면 숫자조차 함수로 표현할 수 있다.

Church numeral에서 자연수 `n`은

```text
어떤 함수 f를 n번 적용한다.
```

라는 방식으로 표현된다.

예를 들어 zero는

```scheme
(define zero
  (lambda (f)
    (lambda (x)
      x)))
```

이다.

`zero`는 `f`를 한 번도 사용하지 않고 `x`를 그대로 반환한다.

successor는

```scheme
(define (successor n)
  (lambda (f)
    (lambda (x)
      (f ((n f) x)))))
```

처럼 정의할 수 있다.

따라서

```text
zero → f를 0번 적용
one  → f를 1번 적용
two  → f를 2번 적용
```

하게 된다.

핵심 표현은

```scheme
((n f) x)
```

이다.

이는

```text
x에 f를 n번 적용한다.
```

라는 의미이다.

덧셈도 직접 숫자를 더하지 않고 함수 적용 횟수를 합치는 방식으로 표현할 수 있다.

```scheme
(define (+ a b)
  (lambda (f)
    (lambda (x)
      ((a f) ((b f) x)))))
```

즉

```text
b번 적용
    ↓
그 결과에 a번 적용
    ↓
총 a+b번 적용
```

이다.

이를 통해 **데이터와 프로시저의 경계가 절대적인 것이 아니라는 점**을 볼 수 있다.

---

## 7. Interval Arithmetic

2.1 후반부에서는 데이터 추상화를 이용해 **불확실한 값**을 표현한다.

어떤 값이 정확히 하나의 숫자가 아니라 일정한 오차를 가진다면

```text
[lower, upper]
```

라는 구간으로 표현할 수 있다.

예를 들어

```text
6.8 ± 10%
```

은

```text
[6.12, 7.48]
```

이라는 interval로 나타낼 수 있다.

```scheme
(define (make-interval a b)
  (cons a b))

(define (lower-bound x)
  (car x))

(define (upper-bound x)
  (cdr x))
```

이제 interval을 사용하는 연산에서는 다시 내부의 `cons`, `car`, `cdr`를 직접 사용할 필요가 없다.

```scheme
(add-interval x y)
(mul-interval x y)
(div-interval x y)
```

등은 오직

```scheme
make-interval
lower-bound
upper-bound
```

를 사용하면 된다.

즉 유리수에서 사용했던 데이터 추상화 구조를 그대로 다른 문제에 적용한 것이다.

---

## 8. 하나의 데이터를 여러 방식으로 바라보기

같은 interval도 여러 방식으로 표현할 수 있다.

기본적으로는

```text
[lower, upper]
```

를 사용했지만, 중심과 폭으로 나타낼 수도 있다.

$$
center = \frac{upper+lower}{2}
$$

$$
width = \frac{upper-lower}{2}
$$

즉

```text
center ± width
```

라는 표현이다.

또한 width를 중심값에 대한 비율로 표현하면

```text
center ± percentage
```

로도 나타낼 수 있다.

$$
percentage
=
\frac{width}{center}\times100
$$

따라서 같은 interval을

```text
[lower, upper]

center ± width

center ± percentage
```

라는 서로 다른 방식으로 바라볼 수 있다.

이 역시 같은 추상 데이터가 여러 representation을 가질 수 있다는 예이다.

---

## 9. 불확실성도 연산을 통해 전파된다

interval arithmetic에서는 숫자뿐 아니라 **불확실성 자체가 연산을 통과하면서 어떻게 변하는가**도 생각해야 한다.

interval의 width는

$$
w(x)=\frac{upper-lower}{2}
$$

이다.

덧셈에서는

$$
w(x+y)=w(x)+w(y)
$$

이고,

뺄셈에서도

$$
w(x-y)=w(x)+w(y)
$$

이다.

따라서 덧셈과 뺄셈에서는 입력 interval의 width만 알고 있어도 결과의 width를 알 수 있다.

하지만 곱셈에서는 그렇지 않다.

예를 들어

```text
[1,3]     width = 1

[10,12]   width = 1
```

로 width가 동일한 두 interval을 생각해보자.

```text
[1,3] × [1,3]
→ [1,9]
→ width = 4
```

이지만

```text
[10,12] × [10,12]
→ [100,144]
→ width = 22
```

이다.

입력의 width는 같지만 결과의 width는 다르다.

곱셈에서는 오차의 크기뿐 아니라 **원래 값의 크기까지 결과에 영향을 주기 때문**이다.

즉

> 같은 불확실성이라도 어떤 연산을 거치는가에 따라 결과에 미치는 영향이 달라진다.

---

## 10. Absolute Error와 Relative Error

`width`는 절대적인 오차의 크기를 나타낸다.

예를 들어

```text
10 ± 1
1000 ± 1
```

은 모두 width가 `1`이다.

하지만 `±1`이 가지는 의미는 두 경우에서 크게 다르다.

```text
10 ± 1    → 약 10% 오차
1000 ± 1  → 약 0.1% 오차
```

따라서 중심값에 비해 오차가 얼마나 큰지를 나타내는 percentage tolerance를 사용할 수 있다.

$$
p=\frac{width}{center}\times100
$$

작은 percentage tolerance를 가진 두 양수 interval을 곱하면 결과의 percentage tolerance는 근사적으로

$$
p_{result}\approx p_1+p_2
$$

가 된다.

즉 작은 상대오차에서는 곱셈을 할 때 상대오차가 대략 더해진다.

---

## 11. Dependency Problem

interval arithmetic을 사용하면서 단순한 `[lower, upper]` 표현의 한계도 드러난다.

예를 들어

```text
x = [1,2]
```

라고 하자.

수학적으로

$$
\frac{x}{x}=1
$$

이다.

같은 `x`를 자기 자신으로 나누기 때문이다.

하지만 단순 interval arithmetic에서는

$$
\frac{[1,2]}{[1,2]}
$$

를 계산한다.

그러면

$$
[0.5,2]
$$

라는 결과가 나온다.

왜냐하면 interval arithmetic은 분자의 `x`와 분모의 `x`가 **같은 하나의 값이라는 관계를 기억하지 못하기 때문**이다.

계산 과정에서는 사실상

```text
분자의 x는 1일 수도 있고
분모의 x는 2일 수도 있다.
```

처럼 취급한다.

하지만 실제로 같은 변수 `x`라면 그런 조합은 불가능하다.

즉 단순 interval 표현은

```text
값이 어느 범위에 존재하는가
```

는 표현하지만

```text
이 값과 다른 값 사이에 어떤 dependency가 존재하는가
```

는 표현하지 못한다.

---

## 12. Algebraically Equivalent Expressions

이 dependency problem 때문에 **수학적으로 동일한 식도 interval arithmetic에서는 다른 결과를 만들 수 있다.**

병렬 저항 공식은

$$
\frac{R_1R_2}{R_1+R_2}
$$

로 표현할 수도 있고

$$
\frac{1}{1/R_1+1/R_2}
$$

로 표현할 수도 있다.

정확한 숫자에서는 두 식이 완전히 같다.

하지만 첫 번째 식에서는

```text
R1 → 두 번 등장
R2 → 두 번 등장
```

하고,

두 번째 식에서는

```text
R1 → 한 번 등장
R2 → 한 번 등장
```

한다.

단순 interval arithmetic에서는 같은 변수의 여러 출현 사이의 dependency를 알 수 없기 때문에, 변수가 반복될수록 실제로 불가능한 조합까지 포함하면서 결과 interval이 넓어질 수 있다.

따라서 가능하다면

```text
같은 불확실한 변수가 반복해서 나타나지 않는 표현
```

을 사용하는 것이 더 tight한 error bound를 만들 수 있다.

---

## 13. 표현은 정보를 보존하기도 하고 잃기도 한다

interval을

```text
[lower, upper]
```

로 표현하면 매우 간단하게 값의 범위를 나타낼 수 있다.

하지만 그 대신

```text
어떤 원래 변수에서 나온 값인가

다른 값과 같은 변수인가

두 값 사이에 어떤 관계가 있는가
```

와 같은 정보는 저장하지 않는다.

예를 들어

```text
x = [1,2]
y = [1,2]
```

일 때

```text
x / x
```

와

```text
x / y
```

는 의미가 다르다.

첫 번째는 같은 값끼리 나누므로 항상 `1`이어야 하지만, 두 번째는 서로 독립적인 값이므로 여러 결과가 가능하다.

하지만 `[lower, upper]`만 보면 둘 다

```text
[1,2] / [1,2]
```

로 보인다.

즉 **데이터 표현을 선택한다는 것은 어떤 정보를 저장하고 어떤 정보를 버릴지를 선택하는 것**이기도 하다.

---

## 14. Chapter 2.1에서 가져갈 것

Chapter 1에서는 반복되는 **계산 과정**을 프로시저로 추상화했다.

Chapter 2.1에서는 같은 사고를 **데이터**에 적용한다.

전체 흐름은 다음과 같다.

```text
구체적인 데이터가 있다
        ↓
데이터를 생성하고 사용하는 연산을 정의한다
        ↓
constructor와 selector를 만든다
        ↓
사용 방법과 내부 표현 사이에
abstraction barrier를 둔다
        ↓
내부 표현을 독립적으로 변경할 수 있게 한다
        ↓
같은 추상 데이터를
전혀 다른 방식으로 표현할 수도 있다
        ↓
표현 방식에 따라
보존되는 정보와 사라지는 정보가 달라진다
```

유리수에서는

```text
make-rat / numer / denom
```

을 통해 데이터 추상화를 만들었다.

pair를 procedure와 integer로 표현하면서 **추상 데이터의 본질이 특정한 저장 형태에 있는 것이 아님**을 확인했다.

Church numeral에서는 숫자조차 함수로 표현할 수 있다는 것을 통해 **데이터와 프로시저의 경계가 절대적이지 않음**을 확인했다.

interval arithmetic에서는 불확실한 값을 추상 데이터로 표현하고 연산을 정의하면서, 표현이 단순할수록 dependency와 같은 정보가 사라질 수도 있다는 **데이터 표현의 한계**까지 확인했다.

결국 Chapter 2.1에서 가장 중요하게 가져갈 것은

> **데이터를 그 내부 표현 자체가 아니라, 데이터에 대해 허용되는 연산과 그 연산들이 만족해야 하는 관계를 통해 바라보는 것**

이다.

Chapter 1이

> **계산 과정에서 반복되는 구조를 발견하고 프로시저로 추상화하는 장**

이었다면,

Chapter 2.1은

> **데이터의 사용과 표현을 분리하고, 데이터를 인터페이스와 관계를 통해 추상화하는 장**

이라고 볼 수 있다.
