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

# Output a Maxima CAS version of the polynomial 
# Exacuting the script below in Maxima CAS will provide with an executable version
# of the Chebyshev approximation, already simplified
# e.g. `ruby chebyshev.rb > output.cas && maxima -b output.cas`
puts "load(orthopoly);"
print "f(x) := #{cs.coef[0]/2.0} "
cs.coef.each_index { |i| 
    if i > 0 then 
        print "+ #{cs.coef[i]} * chebyshev_t (#{i},x)" 
    end
}
puts ";"
puts "g(x) := float(f(2*(x - #{(cs.a+cs.b)/2.0})/ #{cs.b-cs.a}));"
puts "keepfloat: true;"
puts "fortran(expand(g(x)));"
puts "fortran(horner(g(x)));"
