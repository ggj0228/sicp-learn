# lambda calculus

람다 대수는 **함수 정의와 함수 적용만으로 계산을 표현하는 체계**다.

보통 `f(x)=x+2`처럼 쓰는 함수를 `λx.x+2`처럼 이름 없이 표현할 수 있다.

숫자, Boolean, Pair, 재귀도 전부 함수만으로 표현할 수 있다.

---

# 1. 기본 구조

자주 쓰는 표기는 다음 정도다.

- `<name>` : 변수 이름
- `<exp>` : 람다 표현식
- `E`, `E1`, `E2` : 임의의 표현식

람다 표현식은 변수, 함수 정의, 함수 적용으로 나눌 수 있다.

### 변수

`x`

하나의 변수.

### 함수 정의

`λx.E`

`x`를 받아 `E`를 반환하는 함수.

`λx.x`는 받은 값을 그대로 반환하므로 항등함수다.

### 함수 적용

`E1E2`

함수 `E1`에 인자 `E2`를 적용한다.

`(λx.x)y → y`

`x` 자리에 `y`가 들어간 형태다.

`λx.λy.E`는 `λx.(λy.E)`와 같고, 바깥쪽 람다부터 인자를 하나씩 받는다.

---

# 2. Free Variable / Bound Variable

`λx.x`

뒤의 `x`는 앞의 `λx`에 묶여 있으므로 bound variable이다.

`λx.y`

`x`는 `λx`에 묶여 있고, `y`는 자기를 묶는 람다가 없으므로 free variable이다.

- `x` : bound
- `y` : free

같은 이름이어도 위치에 따라 달라질 수 있다.

`(λx.x)x`

괄호 안의 `x`는 `λx`에 묶여 있지만, 맨 오른쪽 `x`는 그 범위 밖이라 free다.

free / bound를 볼 때는 변수 이름보다 **그 변수가 어느 람다의 범위 안에 있는지**를 보면 된다.

---

# 3. Alpha Conversion

속박 변수 이름은 바꿔도 의미가 변하지 않는다.

`λx.x ≡ λy.y`

둘 다 받은 값을 그대로 반환한다.

이 변환은 치환 과정에서 변수 포획을 막을 때 필요하다.

`(λx.λy.xy)y`

여기서 `x` 자리에 `y`를 바로 넣으면 `λy.yy`가 된다. 원래 free였던 `y`가 안쪽 `λy`에 묶여버린다.

먼저 안쪽 변수 이름을 바꾼다.

`λx.λy.xy ≡ λx.λz.xz`

그 다음 치환하면

`(λx.λz.xz)y → λz.yz`

가 된다.

---

# 4. Beta Reduction

람다 함수에 실제 인자를 적용하는 과정이다.

`(λx.E)A → [A/x]E`

`[A/x]E`는 `E` 안에서 현재 `λx`에 묶인 `x`를 `A`로 바꾼다는 뜻이다.

`(λx.x)5 → 5`

`(λx.xx)y → yy`

두 번째 식에서는 `x`가 두 번 있으므로 둘 다 `y`로 치환된다.

---

# 5. Normal Order / Applicative Order

차이는 함수 적용에서 **인자를 언제 평가하느냐**에 있다.

## Normal Order

인자를 먼저 계산하지 않고 함수 본문에 넣는다.

`(λx.x)((λy.y)5)`

바깥쪽부터 적용하면

`(λy.y)5 → 5`

로 끝난다.

## Applicative Order

함수에 인자를 넘기기 전에 인자를 값으로 평가한다.

```scheme
(f (+ 1 2))
```

먼저 `(+ 1 2)`를 계산해서 `(f 3)`으로 만든다.

다만 람다 표현식 자체는 이미 함수값이다.

```scheme
(lambda (x)
  (+ x 1))
```

이 상태에서는 `(+ x 1)`을 실행하지 않는다. 실제 인자가 들어와 함수가 호출될 때 본문이 계산된다.

Scheme은 기본적으로 Applicative Order를 사용한다.

---

# Church Encoding

숫자나 Boolean 같은 값도 함수로 표현할 수 있다.

---

# 6. Church Boolean

True / False를 두 인자 중 하나를 선택하는 함수로 만든다.

`T = λa.λb.a`

`F = λa.λb.b`

`T`는 첫 번째 인자, `F`는 두 번째 인자를 선택한다.

`Tab → a`

`Fab → b`

## AND

`AND = λx.λy.xyF`

`x`에게 `y`, `F`를 넘긴다.

- `x = T` → `y`
- `x = F` → `F`

x가 참이면 y에 따라 결과가 정해지고, x가 거짓이면 결과는 F다.

## OR

`OR = λx.λy.xTy`

`x`에게 `T`, `y`를 넘긴다.

- `x = T` → `T`
- `x = F` → `y`

x가 참이면 바로 T, x가 거짓이면 y가 결과가 된다.

## NOT

`NOT = λx.xFT`

선택지를 `F`, `T` 순으로 둔다.

`NOT T = TFT → F`

`NOT F = FFT → T`

## IF

`IF = λp.λa.λb.pab`

Boolean 자체가 선택 함수라 조건문도 같은 구조로 만들 수 있다.

`IF T a b → a`

`IF F a b → b`

`pab`만으로도 같은 역할을 한다.

---

# 7. Church Numeral

처치 수는 숫자를 직접 저장하지 않고 함수 적용 횟수로 표현한다.

`0 = λs.λz.z`

`s`를 0번 적용.

`1 = λs.λz.sz`

`s`를 1번 적용.

`2 = λs.λz.s(sz)`

`s`를 2번 적용.

`3 = λs.λz.s(s(sz))`

`s`를 3번 적용.

일반적으로 `n = λs.λz.s^n(z)` 형태다.

처치 수 `n`은 함수 `s`를 n번 적용하는 함수다. `(n s)`처럼 함수로 쓸 수 있는 이유도 처치 수 자체가 함수라서 가능하다.

---

# 8. Successor

`n`에서 `n+1`을 만든다.

$$
S=\lambda n.\lambda s.\lambda z.s((ns)z)
$$

`(ns)z`는 `s`를 n번 적용한 결과다. 그 바깥에 `s`를 한 번 더 적용하므로 전체 적용 횟수가 n+1이 된다.

`n=2`라면 `s(s(z))`가 `s(s(s(z)))`로 바뀐다.

---

# 9. Addition

덧셈은 두 처치 수의 적용 횟수를 이어 붙인다.

$$
ADD=\lambda n.\lambda m.\lambda s.\lambda z.(ns)((ms)z)
$$

`(ms)z`에서 `s`를 m번 적용하고, 그 결과에 `(ns)`를 적용해서 `s`를 n번 더 적용한다.

전체 적용 횟수는 `m+n`.

`2+3`이면 `s`가 총 5번 적용된다.

---

# 10. Multiplication

곱셈은 m번 적용하는 함수 자체를 n번 적용한다.

`MULT = λn.λm.λs.n(ms)`

`(ms)`는 `s`를 m번 적용하는 함수다. 그 함수를 n번 적용하면 `s`가 전체적으로 `n×m`번 적용된다.

`2×3`이면 `s`를 3번 적용하는 함수를 2번 적용하므로 총 6번 적용된다.

---

# 11. ISZERO

처치 수가 0인지 검사한다.

`ISZERO = λn.n(λx.F)T`

`λx.F`는 어떤 값을 받아도 `F`를 반환한다.

`n=0`이면 이 함수를 한 번도 적용하지 않으므로 초기값 `T`가 그대로 남는다.

`ISZERO(0)=T`

`n>0`이면 최소 한 번은 `λx.F`가 실행되므로 결과는 `F`.

`ISZERO(n)=F`

---

# 12. Pair

쌍 `(a,b)`도 함수로 표현한다.

`PAIR(a,b)=λz.zab`

`z`는 어떤 값을 꺼낼지 고르는 함수다.

`PAIR(a,b)T → Tab → a`

`PAIR(a,b)F → Fab → b`

`pT`는 Pair `p`의 첫 번째 값, `pF`는 두 번째 값으로 볼 수 있다.

---

# 13. Predecessor

Successor는 `s`를 하나 더 붙이면 되지만, `n-1`은 이미 만들어진 함수 적용 하나를 바로 제거하기 어렵다.

그래서 이전 값을 Pair에 같이 들고 간다.

`Φ(a,b)=(a+1,a)`

첫 번째 값은 1 증가시키고, 기존 첫 번째 값은 두 번째 자리로 넘긴다.

$$
\Phi=\lambda p.\lambda z.z(S(pT))(pT)
$$

`pT`는 현재 Pair의 첫 번째 값, `S(pT)`는 그 값에 1을 더한 결과다.

초기값을 `(0,0)`으로 두면

`(0,0) → (1,0) → (2,1) → (3,2)`

형태로 진행된다.

`Φ`를 3번 적용한 결과가 `(3,2)`이므로 두 번째 값을 꺼내면 2를 얻는다.

$$
P=\lambda n.(n\Phi(\lambda z.z00))F
$$

`n`이 `Φ`를 n번 적용하고, 마지막 `F`가 최종 Pair의 두 번째 값을 선택한다.

`P0=0`

---

# Recursion

# 14. 재귀 함수

일반적인 재귀는 함수 이름으로 자기 자신을 다시 호출한다.

```python
def sum_n(n):
    if n == 0:
        return 0

    return n + sum_n(n - 1)
```

`sum_n(n - 1)`이 재귀 호출 부분이다.

순수 람다 대수에서는 함수 이름을 직접 사용할 수 없으므로 재귀 호출에 사용할 함수를 매개변수로 받는 형태를 만든다.

$$
R=\lambda r.\lambda n.
\begin{cases}
0 & n=0 \\
n+r(n-1) & n>0
\end{cases}
$$

`r`은 재귀 호출에 사용할 함수가 들어갈 자리다.

`r`에 항상 0을 반환하는 함수를 넣으면 `R(r)(3)=3+0=3`까지만 계산된다.

원하는 계산은 `3+2+1`이므로 `r`에도 다시 같은 계산을 수행하는 함수가 들어가야 한다.

필요한 형태는

$$
X=R(X)
$$

를 만족하는 함수 `X`.

---

# 15. Fixed Point Combinator

`X=R(X)`를 만족하는 `X`를 `R`의 고정점이라고 한다.

`R`의 재귀 호출 자리 `r`에 다시 `X`가 들어가므로 재귀 구조를 만들 수 있다.

Normal Order에서는 Y Combinator를 사용할 수 있다.

$$
Y=\lambda f.(\lambda x.f(xx))(\lambda x.f(xx))
$$

중요한 성질은 `YF → F(YF)`.

## 왜 YF → F(YF)인가

`Y`에 `F`를 넣으면

$$
YF\to(\lambda x.F(xx))(\lambda x.F(xx))
$$

반복되는 식을 `A = λx.F(xx)`라고 두면 전체는 `AA`.

첫 번째 `A`의 `x` 자리에 두 번째 `A`를 넣으면 `F(AA)`가 된다.

`AA=YF`였으므로

`F(AA)=F(YF)`

따라서

$$
\boxed{YF\to F(YF)}
$$

`xx`라는 자기 적용 때문에 처음과 같은 구조가 다시 만들어진다.

`F=R`로 두면 `YR→R(YR)`이 된다.

---

# 16. Z Combinator

Scheme은 Applicative Order를 사용하기 때문에 Y Combinator를 그대로 쓰면 문제가 생긴다.

Y는 `YF→F(YF)`를 만든다.

Applicative Order에서는 `F`를 적용하기 전에 인자 `YF`를 먼저 평가한다.

`YF`를 평가하면 다시 `F(YF)`가 생기므로

`YF → F(YF) → F(F(YF)) → F(F(F(YF))) → ...`

형태로 계속 전개될 수 있다.

## Z의 아이디어

Y에서는 `f(xx)`처럼 `xx`가 바로 함수 인자로 들어간다.

Z에서는 `f(λv.(xx)v)`로 바꾼다.

`λv.(xx)v`는 람다 표현식 자체가 함수값이기 때문에 Applicative Order에서도 내부의 `xx`를 바로 실행하지 않는다.

실제 `v`가 들어왔을 때 본문이 실행된다.

## Z의 형태

$$
Z=\lambda f.
(\lambda x.f(\lambda v.(xx)v))
(\lambda x.f(\lambda v.(xx)v))
$$

Y는 `f(xx)`, Z는 `f(λv.(xx)v)` 형태다.

## ZF 전개

$$
ZF\to
(\lambda x.F(\lambda v.(xx)v))
(\lambda x.F(\lambda v.(xx)v))
$$

반복되는 식을 `A = λx.F(λv.(xx)v)`라고 두면 전체는 `AA`.

첫 번째 `A`의 `x` 자리에 두 번째 `A`를 넣으면 `F(λv.(AA)v)`가 된다.

`AA=ZF`였으므로

$$
\boxed{ZF\to F(\lambda v.(ZF)v)}
$$

Y에서는 자기 자신이 바로 인자로 들어가고, Z에서는 람다로 한 번 감싼 함수가 인자로 들어간다.

## R에 적용

`F=R`로 두면

`ZR → R(λv.(ZR)v)`

`R`의 `r` 자리에 `λv.(ZR)v`가 들어간다.

`R` 안에서 `r(a)`를 호출하면

`(λv.(ZR)v)a → (ZR)a`

가 되어 다시 `ZR` 계산으로 돌아간다.

---

# 17. Z Combinator로 1부터 n까지 더하기

만들고 싶은 함수는 다음 형태다.

$$
SUM(n)=
\begin{cases}
0 & n=0 \\
n+SUM(n-1) & n>0
\end{cases}
$$

자기 이름을 직접 쓸 수 없으므로 `SUM` 역할을 할 자리를 `r`로 빼놓는다.

$$
R=\lambda r.\lambda n.
\begin{cases}
0 & n=0 \\
n+r(n-1) & n>0
\end{cases}
$$

Church Encoding으로 쓰면

$$
R=\lambda r.\lambda n.(ISZERO\ n) 0 (nS(r(Pn)))
$$

`ISZERO n`은 n이 0인지 확인하고, `Pn`은 n-1, `r(Pn)`은 n-1에 대한 재귀 결과다.

`nS(r(Pn))`은 그 결과에 Successor를 n번 적용하므로 `n+r(n-1)` 역할을 한다.

실제 재귀 함수는 `SUM=ZR`로 둔다.

`ZR→R(λv.(ZR)v)`가 되면서 `R`의 `r` 자리에 다시 같은 계산을 수행할 함수가 들어간다.

`SUM(3)=3+SUM(2)=3+2+SUM(1)=3+2+1+SUM(0)=6`

---

## Scheme 코드

```scheme
(define R
  (lambda (r)
    (lambda (n)
      (if (= (((iszero n) 1) 0) 1)
          zero
          ((n successor)
           (r (pred n)))))))

(define Z
  (lambda (f)
    ((lambda (x)
       (f
        (lambda (v)
          ((x x) v))))
     (lambda (x)
       (f
        (lambda (v)
          ((x x) v)))))))

(define sum-n
  (Z R))
```

테스트:

```scheme
(to-int (sum-n zero))   ; 0
(to-int (sum-n one))    ; 1
(to-int (sum-n two))    ; 3
(to-int (sum-n three))  ; 6
(to-int (sum-n four))   ; 10
```

---

# 정리

람다 대수에서 본 핵심만 다시 적으면 다음 정도다.

- **Church Numeral**  
  숫자는 **함수 적용 횟수**로 표현한다.

- **Boolean**  
  참/거짓은 **두 인자 중 무엇을 고를지**로 표현한다.

- **Pair**  
  두 값을 함수 안에 넣어두고, **선택 함수**로 꺼낸다.

- **Predecessor**  
  `n-1`은 바로 만들기 어려워서, **이전 값을 Pair에 같이 들고 가는 방식**으로 만든다.

- **Recursion**  
  람다 대수에는 함수 이름이 없으므로,  
  **Y / Z Combinator**로 자기 자신과 같은 계산 구조를 다시 만들어낸다.
.
