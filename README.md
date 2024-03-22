Gaussian processes for complex code evaluation: the emulator package
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="man/figures/emulator.png" width = "150" align="right" />

<!-- badges: start -->

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/emulator)](https://cran.r-project.org/package=emulator)
<!-- badges: end -->

# Overview

To cite the `emulator` package in publications please use Hankin 2005.
The `emulator` package provides R-centric functionality for working with
Gaussian processes. The focus is on approximate evaluation of complex
computer codes. The package is part of the the `BACCO` suite of
software.

# Installation

You can install the released version of permutations from
[CRAN](https://CRAN.R-project.org) with:

``` r
# install.packages("emulator")  # uncomment this to use the package
library("emulator")
#> Loading required package: mvtnorm
```

The package is maintained on
[github](https://github.com/RobinHankin/emulator).

# The `emulator` package in use

Suppose we have a complicated computer program which takes three
parameters as input, and we can run it a total of seven times at
different points in parameter space:

``` r
val
#>       alpha   beta  gamma
#> [1,] 0.7857 0.9286 0.6429
#> [2,] 0.0714 0.3571 0.2143
#> [3,] 0.5000 0.2143 0.7857
#> [4,] 0.3571 0.7857 0.3571
#> [5,] 0.9286 0.5000 0.0714
#> [6,] 0.2143 0.0714 0.5000
#> [7,] 0.6429 0.6429 0.9286
d
#> [1] 3.96 1.06 2.93 2.49 2.11 1.26 4.61
```

Above, `val` shows the seven points in parameter space at which we have
run the code, and `d` shows the output at those points. Now suppose we
wish to know what the code would have produced at point
$p=(0.5, 0.5, 0.5)$, at which the point has not actually been run. This
is straightforward with the package:

``` r
p <- c(0.5,0.5,0.)
fish <- c(1,1,4)
A <- corr.matrix(val,scales=fish)
interpolant(p, d, val, A = A, scales=fish, give=TRUE)
#> $betahat
#>  const  alpha   beta  gamma 
#> -0.363  1.221  1.905  3.072 
#> 
#> $prior
#>      [,1]
#> [1,]  1.2
#> 
#> $beta.var
#>        const  alpha   beta  gamma
#> const  0.995 -0.510 -0.184 -0.713
#> alpha -0.510  0.950 -0.275  0.172
#> beta  -0.184 -0.275  0.914 -0.192
#> gamma -0.713  0.172 -0.192  1.524
#> 
#> $beta.marginal.sd
#> const alpha  beta gamma 
#> 0.997 0.975 0.956 1.234 
#> 
#> $sigmahat.square
#> [1] 0.64
#> 
#> $mstar.star
#>      [,1]
#> [1,] 1.42
#> 
#> $cstar
#> [1] 0.165
#> 
#> $cstar.star
#> [1] 0.2
#> 
#> $Z
#> [1] 0.358
```

Above, object `fish` is a vector of roughness length (“scales”)
corresponding to the small-scale covariance properties of our function.
This may be estimated from the problem or from the datapoints. Matrix
`A` is a normalized variance-covariance matrix for the points of `val`.

The output gives various aspects of the Gaussian process associated with
the original observations. The most interesting one is `mstar.star`
which indicates that the best estimate for the code’s output, if it were
to be run at point $p$, would be about 2.41.

## References

R. K. S. Hankin 2005. “Introducing `BACCO`, an R bundle for Bayesian
analysis of computer code output”. *Journal of Statistical Software*,
14(16)
