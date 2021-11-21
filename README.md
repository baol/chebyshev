# Chebyshev approximation

Math functions are fast enough these days, but there are a couple of situations where a custom
approximation may give you the performance boost you need in the inner loop of your algorithm.

1. You can trade some accuracy for performance
2. You have a complex computation to carry on, and you can approximate the result, skipping a few steps

This is a starting point, and a tool I use for myself. You will need some pencil and paper later on
to expand the polynomial and happly the Horner's method on the results for an actual speedup.

Have a look at [the commented source](chebyshev.rb) and at the resulting implementation of the [cos](cos.rb)

For example the following plot compares the `cos` function and it's approximation computed in the range `[0, π/2]`

![Chebychev approx](chebyshev.jpg)

```sh
$ ruby chebyshev.rb >output.cas

$ cat output.cas 
load(orthopoly);
f(x) := 0.6021947012555464 + -0.513625166679107 * chebyshev_t (1,x)+ -0.10354634426296391 * chebyshev_t (2,x)+ 0.013732034234359841 * chebyshev_t (3,x)+ 0.0013586698380511908 * chebyshev_t (4,x)+ -0.00010726309560354919 * chebyshev_t (5,x)+ -7.046263277091236e-06 * chebyshev_t (6,x)+ 3.9724254333184383e-07 * chebyshev_t (7,x);
g(x) := float(f(2*(x - 45.0)/ 90.0));
keepfloat: true;
fortran(expand(g(x)));
fortran(horner(g(x)));

$ maxima -q -b output.cas 
(%i1) batch("output.cas")
(%i2) load(orthopoly)
(%i3) f(x):=0.6021947012555464+(-0.513625166679107)*chebyshev_t(1,x)
        +(-0.1035463442629639)*chebyshev_t(2,x)
        +0.01373203423435984*chebyshev_t(3,x)
        +0.001358669838051191*chebyshev_t(4,x)
        +(-1.072630956035492e-4)*chebyshev_t(5,x)
        +(-7.046263277091236e-6)*chebyshev_t(6,x)
        +3.972425433318438e-7*chebyshev_t(7,x)
(%i4) g(x):=float(f((2*(x-45.0))/90.0))
                                        2 (x - 45.0)
(%o4)                   g(x) := float(f(------------))
                                            90.0
(%i5) keepfloat:true
(%i6) fortran(expand(g(x)))
      6.803746616326524d-17*x**7-4.8585798600208646d-14*x**6+6.832336963
     1   78597d-13*x**5+3.838208357065704d-9*x**4+6.337658644663928d-10*
     2   x**3-1.5231576820791043d-4*x**2+3.0089903955629604d-8*x+9.99999
     3   9788651639d-1
(%o6)                                done
(%i7) fortran(horner(g(x)))
      1.0d+0*(x*(x*(x*(x*(x*((6.803746616326523d-17*x-4.8585798600208646
     1   d-14)*x+6.832336963785987d-13)+3.8382083570657033d-9)+6.3376586
     2   44663928d-10)-1.5231576820791043d-4)+3.0089903955629604d-8)+9.9
     3   99999788651639d-1)
(%o7)                                done
```

> happy hacking
>
> baol
