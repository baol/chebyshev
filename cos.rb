# Using the rb-gsl package to compute Chebyshev coefficients for the Chebyshef approximation
# of trigonometric (and generic) functions in an interval
require("gsl")

# Chebyshev polynomial of the first kind
def t(n, x) 
    if n >= 2
        2.0 * x * t(n - 1, x) - t(n - 2, x)
    elsif n == 1
        x
    elsif n == 0
        1.0
    end
end

# Approximate an example function: cos in degree
f = GSL::Function.alloc { |x|
    Math::cos((x) * Math::PI / 180.0)
}

# Inizialize rb-gsl for Chebyshev
cs = GSL::Cheb.alloc(7)

# Approximage f in the given range [0, 90]
cs.init(f, -0.0, 90.0)

# One could use cs.eval, but the purpose here is to get an explicit polynomial
# That we can expand, and compute using the https://en.wikipedia.org/wiki/Horner%27s_method
def cheb(deg, cs)
    x = 2.0 * (deg - (cs.a + cs.b) / 2.0) / (cs.b - cs.a) 
    cs.coef[0]/2.0 + (1...cs.coef.size).map { |i| cs.coef[i] * t(i, x)}.sum
end

# Print the approximation in some points
puts cheb(0, cs)
puts cheb(45, cs)
puts cheb(90, cs)
